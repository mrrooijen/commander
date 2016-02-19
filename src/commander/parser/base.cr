abstract class Commander::Parser::Base
  getter param : String
  getter next_param : String | Nil
  getter skip_next : Proc(Array(Int32))
  getter flags : Flags
  getter options : Options

  def initialize(@param, @next_param, @skip_next, @flags, @options)
  end

  private def no_such_flag!(flag)
    raise Exception.new("Flag '#{flag}' does not exist")
  end

  private def missing_argument!(argument)
    raise Exception.new("Missing value for argument: #{argument}")
  end

  private def cant_take_argument!(chars, char)
    raise Exception.new(
      "Only the last flag in '-#{chars.join}' can " +
        "take an argument.\n'-#{char}' takes an argument.")
  end

  private def doesnt_take_arguments!(flag)
    raise Exception.new("The '#{flag}' flag doesn't take any arguments.")
  end
end
