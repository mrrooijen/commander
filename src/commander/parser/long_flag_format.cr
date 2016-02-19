require "./base"

class Commander::Parser::LongFlagFormat < Commander::Parser::Base
  PATTERN        = /^\-\-[a-zA-Z0-9-]{1,}=?/
  EQUALS_PATTERN = /^\-\-[a-zA-Z0-9-]{1,}=/

  protected def match?
    !!PATTERN.match(param)
  end

  protected def parse!
    if contains_equals?
      with_equals
    else
      without_equals
    end
  end

  private def contains_equals?
    !!EQUALS_PATTERN.match(param)
  end

  private def with_equals
    parts = param.split('=')
    key = parts[0]
    value = parts[1..-1].join('=')

    missing_argument!(param) if value == ""

    if flag = flags.find_long(key)
      if flag.type == Bool
        doesnt_take_arguments!(flag.long)
      end

      options.set(flag.name, flag.cast(value))
      return true
    end

    no_such_flag!(key)
  end

  private def without_equals
    if flag = flags.find_long(param)
      if flag.type == Bool
        options.set(flag.name, !flag.default)
        return true
      else
        if value = next_param
          options.set(flag.name, flag.cast(value))
          skip_next.call
          return true
        else
          missing_argument!(param)
        end
      end
    end

    no_such_flag!(param)
  end
end
