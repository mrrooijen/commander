class Commander::Options
  getter string, int, float, bool, null

  def initialize
    @string = OptionHash(String, Option(String)).new
    @int = OptionHash(String, Option(Int32) | Option(Int64)).new
    @float = OptionHash(String, Option(Float32) | Option(Float64)).new
    @bool = OptionHash(String, Option(Bool)).new
    @null = OptionHash(String, Option(Nil)).new
  end

  def set(key : String, option : Option(String))
    string[key] = option
  end

  def set(key : String, option : Option(Int32) | Option(Int64))
    int[key] = option
  end

  def set(key : String, option : Option(Float32) | Option(Float64))
    float[key] = option
  end

  def set(key : String, option : Option(Bool))
    bool[key] = option
  end

  def set(key : String, option : Option(Nil))
    null[key] = option
  end

  def globals
    Options.new.tap do |options|
      string.select { |_, v| v.global? }.each_with_index do |(key, val)|
        options.set(key, val)
      end
      int.select { |_, v| v.global? }.each_with_index do |(key, val)|
        options.set(key, val)
      end
      float.select { |_, v| v.global? }.each_with_index do |(key, val)|
        options.set(key, val)
      end
      bool.select { |_, v| v.global? }.each_with_index do |(key, val)|
        options.set(key, val)
      end
      null.select { |_, v| v.global? }.each_with_index do |(key, val)|
        options.set(key, val)
      end
    end
  end

  def +(other_options)
    Options.new.tap do |options|
      string.merge(other_options.string).each_with_index do |(key, val)|
        options.set(key, val)
      end
      int.merge(other_options.int).each_with_index do |(key, val)|
        options.set(key, val)
      end
      float.merge(other_options.float).each_with_index do |(key, val)|
        options.set(key, val)
      end
      bool.merge(other_options.bool).each_with_index do |(key, val)|
        options.set(key, val)
      end
      null.merge(other_options.null).each_with_index do |(key, val)|
        options.set(key, val)
      end
    end
  end
end
