class Commander::Command
  property use : String
  property short : String
  property long : String
  property runner : Runner | OptionalRunner | NoReturnRunner | ArrayStringRunner

  getter commands : Commands
  getter flags : Flags

  def initialize(@help = false)
    @use = ""
    @short = ""
    @long = ""
    @runner = Runner.new { |arguments, options| }
    @commands = Commands.new
    @flags = Flags.new

    unless help?
      flags.add(build_help_flag)
      commands.add(build_help_command)
    end
  end

  def initialize(help = false)
    initialize(help)
    yield self
  end

  def run(&runner : Runner)
    @runner = runner
  end

  def run(runner : Runner)
    @runner = runner
  end

  def help
    <<-EOS
      #{description}

      Usage:
        #{usage}

      Commands:
        #{command_list}

      Flags:
        #{flag_list}
    EOS
  end

  def invoke(params : Params, command : Command = self)
    if param = params.shift?
      if sub_command = find_command(param)
        sub_command.invoke(params, sub_command)
        return
      end

      params.unshift(param)
    end

    parser = Parser.new(params, flags)
    options, arguments = parser.parse

    if options.bool.delete("help")
      puts help
      exit 0
    end

    command.runner.call(options, arguments)
  end

  protected def name
    use.split(" ").first? || use
  end

  private def help?
    @help
  end

  private def build_help_command
    Command.new(true) do |cmd|
      cmd.use = "help [command]"
      cmd.short = "Help about any command."
      cmd.long = "Help about any command."

      cmd.run do |options, arguments|
        if arguments.empty?
          puts help
          exit 0
        end

        argument = arguments.first
        sub_command = find_command(argument)

        if sub_command
          puts sub_command.help
          exit 0
        else
          STDERR.puts "No such command: #{argument}"
          exit 2
        end
      end
    end
  end

  private def build_help_flag
    Flag.new do |flag|
      flag.name = "help"
      flag.long = "--help"
      flag.short = "-h"
      flag.default = false
      flag.description = "Help for this command."
    end
  end

  private def find_command(name : String) : Command | Nil
    commands.each { |cmd| return cmd if cmd.name == name }
    nil
  end

  private def description
    out = name
    out += " - #{long}" if long.size > 0
    out
  end

  private def usage
    out = use
    out += " [command]" if commands.size > 1
    out += " [flags]" if flags.size > 1
    out + " [arguments]"
  end

  private def command_list
    pairs = commands.to_a.sort_by(&.name).map do |cmd|
      {cmd.use, cmd.short}
    end

    align(pairs)
  end

  private def flag_list
    pairs = flags.to_a.sort_by(&.name).map do |flag|
      result = ""

      if flag.short? && flag.long?
        result += "#{flag.short}, #{flag.long}"
      elsif flag.short?
        result += flag.short
      elsif flag.long?
        result += "    #{flag.long}"
      end

      description = "#{flag.description} default: '#{flag.default}'."

      {result, description}
    end

    align(pairs)
  end

  private def align(pair, delimeter = " #")
    max_size = pair.reduce(0) do |max, entry|
      size = entry[0].size
      size > max ? size : max
    end

    entries = pair.map do |entry|
      padding = max_size - entry[0].size
      "#{entry[0]}#{" " * padding} #{delimeter} #{entry[1]}"
    end

    entries.join("\n    ")
  end
end
