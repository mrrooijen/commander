require "./base"

class Commander::Parser::ShortFlagFormat < Commander::Parser::Base
  PATTERN = /^\-[a-zA-Z0-9]{1,}/

  protected def match?
    !!PATTERN.match(param)
  end

  protected def parse!
    if chars = param.chars[1..-1]
      last_index = chars.size - 1
      chars.each_with_index do |char, index|
        if flag = flags.find_short("-#{char}")
          if index != last_index && flag.type != Bool
            cant_take_argument!(chars, char)
          end
        end
      end
    end

    chars.each do |char|
      flag_char = "-#{char}"
      if flag = flags.find_short(flag_char)
        if flag.type == Bool
          options.set(flag.name, !flag.default)
          next
        else
          if value = next_param
            options.set(flag.name, flag.cast(value))
            skip_next.call
            next
          else
            missing_argument!(flag_char)
          end
        end
      end

      no_such_flag!(flag_char)
    end

    true
  end
end
