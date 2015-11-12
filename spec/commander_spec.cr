require "./spec_helper"

class BlockRanException < Exception
end

describe Commander do
  describe "flag" do
    describe "generic" do
      it "raises an exception if flag name is missing" do
        message = "Flag requires a name."
        expect_raises(Commander::Flag::Exception, message) do
          Commander::Command.new do |cmd|
            cmd.flags.add do |flag|
            end
          end
        end
      end

      it "raises an exception if both short- and long formats are missing" do
        message = "Flag 'example' requires at least a " +
          "short flag or a long flag."
        expect_raises(Commander::Flag::Exception, message) do
          Commander::Command.new do |cmd|
            cmd.flags.add do |flag|
              flag.name = "example"
            end
          end
        end
      end

      it "raises an exception if short flag doesn't exist" do
        command = Commander::Command.new
        message = "Flag '-f' does not exist"
        expect_raises(Commander::Parser::Exception, message) do
          command.invoke(["-f"])
        end
      end

      it "raises an exception if long flag doesn't exist" do
        command = Commander::Command.new
        message = "Flag '--example' does not exist"
        expect_raises(Commander::Parser::Exception, message) do
          command.invoke(["--example"])
        end
      end

      it "raises an exception if long flag format is invalid" do
        message = "Long flag '-example-flag' is invalid. " +
          "Long flags must start with a '--', followed by a " +
          "one or more alphanumeric characters and dashes " +
          "(i.e. '--example-flag')."
        expect_raises(Commander::Flag::Exception, message) do
          Commander::Command.new do |cmd|
            cmd.flags.add do |flag|
              flag.name = "example"
              flag.long = "-example-flag"
              flag.default = false
            end
          end
        end
      end

      it "raises an exception if short flag format is invalid" do
        message = "Short flag '-example' is invalid. " +
          "Short flags must start with a '-', followed by a single " +
          "alphanumeric character (i.e. '-e')."
        expect_raises(Commander::Flag::Exception, message) do
          Commander::Command.new do |cmd|
            cmd.flags.add do |flag|
              flag.name = "example"
              flag.short = "-example"
              flag.default = false
            end
          end
        end
      end

      it "raises an exception if default doesn't exist" do
        command = Commander::Command.new
        message = "Flag requires a default value " +
          "-- use String, Int32, Int64, Float32, Float64, Bool"

        expect_raises(Commander::Flag::Exception, message) do
          command.flags.add do |flag|
            flag.name = "example"
            flag.long = "--example"
          end
        end
      end

      it "raises an exception if description doesn't exist" do
        command = Commander::Command.new
        message = "Flag 'example' requires a description."

        expect_raises(Commander::Flag::Exception, message) do
          command.flags.add do |flag|
            flag.name = "example"
            flag.long = "--example"
            flag.default = false
          end
        end
      end
    end

    describe "bool" do
      it "raises an exception if flag receives an argument" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.long = "--example"
            flag.default = false
            flag.description = "example description"
          end
        end

        message = "The '--example' flag doesn't take any arguments."
        expect_raises(Commander::Parser::Exception, message) do
          command.invoke(["--example=true"])
        end
      end

      [true, false].each do |bool|
        it "defaults the option to #{bool}" do
          command = Commander::Command.new do |cmd|
            cmd.flags.add do |flag|
              flag.name = "example"
              flag.short = "-e"
              flag.default = bool
              flag.description = "example description"
            end

            cmd.run do |options, _|
              options.bool["example"].should eq bool
              raise BlockRanException.new
            end
          end

          expect_raises(BlockRanException) do
            command.invoke([] of String)
          end
        end

        it "sets the option to #{!bool} with --example" do
          command = Commander::Command.new do |cmd|
            cmd.flags.add do |flag|
              flag.name = "example"
              flag.long = "--example"
              flag.default = !bool
              flag.description = "example description"
            end

            cmd.run do |options, _|
              options.bool["example"].should eq bool
              raise BlockRanException.new
            end
          end

          expect_raises(BlockRanException) do
            command.invoke(["--example"])
          end
        end

        it "sets the option to #{!bool} with -e" do
          command = Commander::Command.new do |cmd|
            cmd.flags.add do |flag|
              flag.name = "example"
              flag.short = "-e"
              flag.default = !bool
              flag.description = "example description"
            end

            cmd.run do |options, _|
              options.bool["example"].should eq bool
              raise BlockRanException.new
            end
          end

          expect_raises(BlockRanException) do
            command.invoke(["-e"])
          end
        end
      end
    end

    describe "string" do
      it "raises an exception if flag is missing an argument" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.long = "--example"
            flag.short = "-e"
            flag.default = "example-value"
            flag.description = "example description"
          end
        end

        message = "Missing value for argument: --example"
        expect_raises(Commander::Parser::Exception, message) do
          command.invoke(["--example"])
        end

        message = "Missing value for argument: --example"
        expect_raises(Commander::Parser::Exception, message) do
          command.invoke(["--example="])
        end

        message = "Missing value for argument: -e"
        expect_raises(Commander::Parser::Exception, message) do
          command.invoke(["-e"])
        end
      end

      it "defaults the option to 'example-value'" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.long = "--example"
            flag.default = "example-value"
            flag.description = "example description"
          end

          cmd.run do |options, _|
            options.string["example"].should eq "example-value"
            raise BlockRanException.new
          end
        end

        expect_raises(BlockRanException) do
          command.invoke([] of String)
        end
      end

      it "sets the option to 'crystal' with --example=" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.long = "--example"
            flag.default = "example-value"
            flag.description = "example description"
          end

          cmd.run do |options, _|
            options.string["example"].should eq "crystal"
            raise BlockRanException.new
          end
        end

        expect_raises(BlockRanException) do
          command.invoke(["--example=crystal"])
        end
      end

      it "sets the option to 'crystal' with --example" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.long = "--example"
            flag.default = "example-value"
            flag.description = "example description"
          end

          cmd.run do |options, _|
            options.string["example"].should eq "crystal"
            raise BlockRanException.new
          end
        end

        expect_raises(BlockRanException) do
          command.invoke(["--example", "crystal"])
        end
      end

      it "sets the option to 'crystal' with -e" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.short = "-e"
            flag.default = "example-value"
            flag.description = "example description"
          end

          cmd.run do |options, _|
            options.string["example"].should eq "crystal"
            raise BlockRanException.new
          end
        end

        expect_raises(BlockRanException) do
          command.invoke(["-e", "crystal"])
        end
      end
    end

    describe "int" do
      it "raises an exception if flag is missing an argument" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.long = "--example"
            flag.short = "-e"
            flag.default = 1
            flag.description = "example description"
          end
        end

        message = "Missing value for argument: --example"
        expect_raises(Commander::Parser::Exception, message) do
          command.invoke(["--example"])
        end

        message = "Missing value for argument: --example"
        expect_raises(Commander::Parser::Exception, message) do
          command.invoke(["--example="])
        end

        message = "Missing value for argument: -e"
        expect_raises(Commander::Parser::Exception, message) do
          command.invoke(["-e"])
        end
      end

      it "raises an exception if uncastable type was provided" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.long = "--example"
            flag.default = 0
            flag.description = "example description"
          end
        end

        message = "Invalid value 'not an int' for flag --example\n" +
          "Required type: Int32"
        expect_raises(Commander::Flag::Exception, message) do
          command.invoke(["--example", "not an int"])
        end
      end

      it "defaults the option to '0'" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.long = "--example"
            flag.default = 0
            flag.description = "example description"
          end

          cmd.run do |options, _|
            options.int["example"].should eq 0 as Int32
            raise BlockRanException.new
          end
        end

        expect_raises(BlockRanException) do
          command.invoke([] of String)
        end
      end

      it "sets the option to '9' with --example=" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.long = "--example"
            flag.default = 0
            flag.description = "example description"
          end

          cmd.run do |options, _|
            options.int["example"].should eq 9 as Int32
            raise BlockRanException.new
          end
        end

        expect_raises(BlockRanException) do
          command.invoke(["--example=9"])
        end
      end

      it "sets the option to '9' with --example" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.long = "--example"
            flag.default = 0
            flag.description = "example description"
          end

          cmd.run do |options, _|
            options.int["example"].should eq 9 as Int32
            raise BlockRanException.new
          end
        end

        expect_raises(BlockRanException) do
          command.invoke(["--example", "9"])
        end
      end

      it "sets the option to '9' with -e" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.short = "-e"
            flag.default = 0
            flag.description = "example description"
          end

          cmd.run do |options, _|
            options.int["example"].should eq 9 as Int32
            raise BlockRanException.new
          end
        end

        expect_raises(BlockRanException) do
          command.invoke(["-e", "9"])
        end
      end
    end

    describe "float" do
      it "raises an exception if flag is missing an argument" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.long = "--example"
            flag.short = "-e"
            flag.default = 1.9
            flag.description = "example description"
          end
        end

        message = "Missing value for argument: --example"
        expect_raises(Commander::Parser::Exception, message) do
          command.invoke(["--example"])
        end

        message = "Missing value for argument: --example"
        expect_raises(Commander::Parser::Exception, message) do
          command.invoke(["--example="])
        end

        message = "Missing value for argument: -e"
        expect_raises(Commander::Parser::Exception, message) do
          command.invoke(["-e"])
        end
      end

      it "raises an exception if uncastable type was provided" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.long = "--example"
            flag.default = 1.1
            flag.description = "example description"
          end
        end

        message = "Invalid value 'not a float' for flag --example\n" +
          "Required type: Float64"
        expect_raises(Commander::Flag::Exception, message) do
          command.invoke(["--example", "not a float"])
        end
      end

      it "defaults the option to '1.1'" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.long = "--example"
            flag.default = 1.1
            flag.description = "example description"
          end

          cmd.run do |options, _|
            options.float["example"].should eq 1.1 as Float64
            raise BlockRanException.new
          end
        end

        expect_raises(BlockRanException) do
          command.invoke([] of String)
        end
      end

      it "sets the option to '1.9' with --example=" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.long = "--example"
            flag.default = 1.1
            flag.description = "example description"
          end

          cmd.run do |options, _|
            options.float["example"].should eq 1.9 as Float64
            raise BlockRanException.new
          end
        end

        expect_raises(BlockRanException) do
          command.invoke(["--example=1.9"])
        end
      end

      it "sets the option to '1.9' with --example" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.long = "--example"
            flag.default = 1.1
            flag.description = "example description"
          end

          cmd.run do |options, _|
            options.float["example"].should eq 1.9 as Float64
            raise BlockRanException.new
          end
        end

        expect_raises(BlockRanException) do
          command.invoke(["--example", "1.9"])
        end
      end

      it "sets the option to '1.9' with -e" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.short = "-e"
            flag.default = 1.1
            flag.description = "example description"
          end

          cmd.run do |options, _|
            options.float["example"].should eq 1.9 as Float64
            raise BlockRanException.new
          end
        end

        expect_raises(BlockRanException) do
          command.invoke(["-e", "1.9"])
        end
      end

      it "accepts int and casts to float" do
        command = Commander::Command.new do |cmd|
          cmd.flags.add do |flag|
            flag.name = "example"
            flag.short = "-e"
            flag.default = 1.1
            flag.description = "example description"
          end

          cmd.run do |options, _|
            options.float["example"].should eq 19.0 as Float64
            raise BlockRanException.new
          end
        end

        expect_raises(BlockRanException) do
          command.invoke(["-e", "19"])
        end
      end
    end
  end

  describe "argument" do
    it "should extract arguments" do
      command = Commander::Command.new do |cmd|
        cmd.flags.add do |flag|
          flag.name = "a"
          flag.short = "-a"
          flag.default = false
          flag.description = "example description"
        end

        cmd.flags.add do |flag|
          flag.name = "b"
          flag.short = "-b"
          flag.default = "example-one"
          flag.description = "example description"
        end

        cmd.flags.add do |flag|
          flag.name = "c"
          flag.long = "--c"
          flag.default = "example-two"
          flag.description = "example description"
        end

        cmd.flags.add do |flag|
          flag.name = "d"
          flag.long = "--d"
          flag.default = "example-three"
          flag.description = "example description"
        end

        cmd.run do |_, arguments|
          parsed_args = ["arg1", "arg2", "arg3", "arg4", "arg5"]
          arguments.should eq parsed_args
          raise BlockRanException.new
        end
      end

      expect_raises(BlockRanException) do
        command.invoke([
          "arg1",
          "-a",
          "arg2",
          "-b", "value-one",
          "arg3",
          "--c", "value-two",
          "arg4",
          "--d=value-three",
          "arg5",
        ])
      end
    end
  end
end
