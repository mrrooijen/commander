require "./spec_helper"

describe Commander::Flag do

  it "parses descriptive argument from short" do
    flag = Commander::Flag.new do |flag|
      flag.name = "suffix"
      flag.description = flag.name
      flag.short = "-s DIR"
      flag.long = "--suffix"
      flag.default = ""
    end

    flag.long.should eq("--suffix")
    flag.short.should eq("-s")
    flag.arg.should eq("DIR")
  end

  it "parses descriptive argument from long" do
    flag = Commander::Flag.new do |flag|
      flag.name = "suffix"
      flag.description = flag.name
      flag.short = "-s"
      flag.long = "--suffix DIR"
      flag.default = ""
    end

    flag.long.should eq("--suffix")
    flag.short.should eq("-s")
    flag.arg.should eq("DIR")
  end

  it "parses descriptive argument from short if both present" do
    flag = Commander::Flag.new do |flag|
      flag.name = "suffix"
      flag.description = flag.name
      flag.short = "-s DIR"
      flag.long = "--suffix DIR"
      flag.default = ""
    end

    flag.long.should eq("--suffix")
    flag.short.should eq("-s")
    flag.arg.should eq("DIR")
  end

  it "ignores descriptive argument if absent from both short and long" do
    flag = Commander::Flag.new do |flag|
      flag.name = "suffix"
      flag.description = flag.name
      flag.short = "-s"
      flag.long = "--suffix"
      flag.default = ""
    end

    flag.long.should eq("--suffix")
    flag.short.should eq("-s")
    flag.arg.should be_nil
  end
end
