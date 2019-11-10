class Commander::Commands
  include Enumerable(Command)

  getter commands : Array(Command)

  def initialize(@flags : Flags)
    @commands = [] of Command
  end

  def each
    commands.each { |command| yield command }
  end

  def add
    flags = Flags.new(@flags.select(&.persistent))
    yield command = Command.new(false, flags)
    add(command)
  end

  def add(command : Command)
    commands << command
  end
end
