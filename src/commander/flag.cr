class Commander::Flag
  class Exception < Commander::Exception; end

  INT_PATTERN   = /^\d+$/
  FLOAT_PATTERN = /^(\d+|\d+\.\d+)$/
  SHORT_PATTERN = /^\-[a-zA-Z0-9]$/
  LONG_PATTERN  = /^\-\-[a-zA-Z0-9-]+$/

  property name : String
  property short : String
  property long : String
  property default : Types
  property description : String

  def initialize
    @name = ""
    @short = ""
    @long = ""
    @description = ""
    @default = nil
  end

  def initialize
    initialize
    yield self
  end

  protected def type
    default.class
  end

  protected def cast(value : String) : Types
    case default
    when Int32, Int64
      raise Exception.new if !value.match(INT_PATTERN)

      if default.is_a?(Int32)
        value.to_i32
      else
        value.to_i64
      end
    when Float32, Float64
      raise Exception.new if !value.match(FLOAT_PATTERN)

      if default.is_a?(Float32)
        value.to_f32
      else
        value.to_f64
      end
    else
      value
    end
  rescue
    message = "Invalid value '#{value}' for flag"

    if short.size > 0
      message += " #{short}"
    end

    if short.size > 0 && long.size > 0
      message += " (#{long})"
    elsif long.size > 0
      message += " #{long}"
    end

    message += "\nRequired type: #{type}"

    raise Exception.new(message)
  end

  protected def short?
    !!short.match(SHORT_PATTERN)
  end

  protected def long?
    !!long.match(LONG_PATTERN)
  end

  protected def validate!
    validate_flag_name!
    validate_long_format!
    validate_short_format!
    validate_flag_availability!
    validate_default!
    validate_description!
  end

  private def validate_flag_name!
    return unless name == ""
    raise Exception.new("Flag requires a name.")
  end

  private def validate_long_format!
    return unless long != "" && !long?
    raise Exception.new(
      "Long flag '#{long}' is invalid. " +
        "Long flags must start with a '--', followed by " +
        "a one or more alphanumeric characters and dashes " +
        "(i.e. '--example-flag').")
  end

  private def validate_short_format!
    return unless short != "" && !short?
    raise Exception.new(
      "Short flag '#{short}' is invalid. " +
        "Short flags must start with a '-', followed by " +
        "a single alphanumeric character (i.e. '-e').")
  end

  private def validate_flag_availability!
    return if short? || long?
    raise Exception.new(
      "Flag '#{name}' requires at least a " +
        "short flag or a long flag.")
  end

  private def validate_default!
    return unless default.nil?
    types = [String, Int32, Int64, Float32, Float64, Bool]
    raise Exception.new(
      "Flag requires a default value " +
        "-- use #{types.join(", ")}")
  end

  private def validate_description!
    return unless description == ""
    raise Exception.new("Flag '#{name}' requires a description.")
  end
end
