require "./spec_helper"

module Commander
  describe Flags do
    flag_one = Commander::Flag.new do |f|
      f.name = "what"
      f.description = f.name
      f.short = "-w"
      f.default = "what"
    end

    flag_two = Commander::Flag.new do |f|
      f.name = "even"
      f.description = f.name
      f.short = "-e"
      f.default = "even"
    end

    it "can add flags individually" do
      collect = Commander::Flags.new
      collect.add flag_one
      collect.add flag_two

      collect.flags.size.should eq(2)
      collect.flags.should eq [flag_one, flag_two]
    end

    it "can add multiple flags at once" do
      collect = Commander::Flags.new
      collect.add flag_two, flag_one

      collect.flags.size.should eq(2)
      collect.flags.should eq [flag_two, flag_one]
    end

    it "can add an array of flags" do
      collect = Commander::Flags.new
      collect.add [flag_two, flag_one]

      collect.flags.size.should eq(2)
      collect.flags.should eq [flag_two, flag_one]
    end
  end
end
