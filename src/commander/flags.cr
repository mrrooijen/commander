class Commander::Flags
  include Enumerable(Flag)

  getter flags : Array(Flag)

  def initialize
    @flags = [] of Flag
  end

  def each
    flags.each { |flag| yield flag }
  end

  def add(*flags)
    add flags.to_a
  end

  def add(flags : Array(Commander::Flag))
    flags.each { |flag| add(flag) }
  end

  def add(flag : Commander::Flag)
    flag.validate!
    flags << flag
  end

  def add
    yield(flag = Flag.new)
    add(flag)
  end

  protected def find_long(value : String)
    each { |flag| return flag if flag.long == value }
    nil
  end

  protected def find_short(value : String)
    each { |flag| return flag if flag.short == value }
    nil
  end
end
