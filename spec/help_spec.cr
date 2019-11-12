require "./spec_helper"

describe Commander do
  it "should render a full example help page" do
    cli = Commander::Command.new do |cmd|
      cmd.use = "my_program"
      cmd.long = "my program's (long) description."

      cmd.flags.add do |flag|
        flag.name = "suffix-short"
        flag.short = "-s DIR"
        flag.default = ""
        flag.description = "Suffix specified using a short flag and descriptive argument."
      end

      cmd.flags.add do |flag|
        flag.name = "suffix-long"
        flag.long = "--suffix DIR"
        flag.default = ""
        flag.description = "Suffix specified using a long flag and descriptive argument."
      end

      cmd.flags.add do |flag|
        flag.name = "suffix-dir-on-short"
        flag.short = "-s DIR"
        flag.long = "--suffix"
        flag.default = ""
        flag.description = "Suffix specified using a short flag with descriptive argument and long flag."
      end

      cmd.flags.add do |flag|
        flag.name = "suffix-dir-on-long"
        flag.short = "-s"
        flag.long = "--suffix DIR"
        flag.default = ""
        flag.description = "Suffix specified using a long flag with descriptive argument and short flag."
      end

      cmd.flags.add do |flag|
        flag.name = "suffix-dir-on-both"
        flag.short = "-s DIR"
        flag.long = "--suffix DIR"
        flag.default = ""
        flag.description = "Suffix specified using a long flag with descriptive argument and short flag with descriptive argument."
      end

      cmd.flags.add do |flag|
        flag.name = "env"
        flag.short = "-e"
        flag.long = "--env"
        flag.default = "development"
        flag.description = "The environment to run in."
      end

      cmd.flags.add do |flag|
        flag.name = "port"
        flag.short = "-p"
        flag.long = "--port"
        flag.default = 8080
        flag.description = "The port to bind to."
      end

      cmd.flags.add do |flag|
        flag.name = "timeout"
        flag.short = "-t"
        flag.long = "--timeout"
        flag.default = 29.5
        flag.description = "The wait time before dropping the connection."
      end

      cmd.flags.add do |flag|
        flag.name = "verbose"
        flag.short = "-v"
        flag.long = "--verbose"
        flag.default = false
        flag.description = "Enable more verbose logging."
        flag.persistent = true
      end

      cmd.commands.add do |cmd|
        cmd.use = "kill <pid>"
        cmd.short = "Kills server by pid."
        cmd.long = cmd.short
        cmd.run do |options, arguments|
          arguments
        end
      end
    end

    cli.help.should eq <<-EOS
      my_program - my program's (long) description.

      Usage:
        my_program [command] [flags] [arguments]

      Commands:
        help [command]  Help about any command.
        kill <pid>      Kills server by pid.

      Flags:
        -e, --env         The environment to run in. default: 'development'
        -h, --help        Help for this command.
        -p, --port        The port to bind to. default: 8080
        -s, --suffix DIR  Suffix specified using a long flag with descriptive argument and short flag with descriptive argument.
        -s, --suffix DIR  Suffix specified using a long flag with descriptive argument and short flag.
        -s, --suffix DIR  Suffix specified using a short flag with descriptive argument and long flag.
            --suffix DIR  Suffix specified using a long flag and descriptive argument.
        -s DIR            Suffix specified using a short flag and descriptive argument.
        -t, --timeout     The wait time before dropping the connection. default: 29.5
        -v, --verbose     Enable more verbose logging.
    EOS

    cli.commands.to_a[1].help.should eq <<-EOS
      kill - Kills server by pid.

      Usage:
        kill <pid> [flags] [arguments]

      Commands:
        help [command]  Help about any command.

      Flags:
        -h, --help     Help for this command.
        -v, --verbose  Enable more verbose logging.
    EOS
  end
end
