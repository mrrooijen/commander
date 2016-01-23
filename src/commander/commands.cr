class Commander::Commands
  include Enumerable(Command)

  getter commands : Array(Command)

  def initialize
    @commands = [] of Command
  end

  def each
    commands.each { |command| yield command }
  end

  def add
    yield(command = Command.new)
    add(command)
  end

  def add(command : Command)
    commands << command
  end
end
