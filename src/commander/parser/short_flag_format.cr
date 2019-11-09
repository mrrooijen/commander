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
          option = Option.build(!flag.default, flag)
          options.set(option.key, option)
          next
        else
          if value = next_param
            option = Option.build(flag.cast(value), flag)
            options.set(option.key, option)
            skip_next.call
            next
          else
            missing_argument!(flag_char)
          end
        end
      end

      return false
    end

    true
  end
end
