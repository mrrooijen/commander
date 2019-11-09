class Commander::Option(T)
  getter value, flag

  def initialize(@value : T, @flag : Flag); end

  def key
    flag.name
  end

  def global?
    !!flag.global
  end

  def self.build(value, flag)
    case value
    when String
      Option(String).new(value, flag)
    when Int32
      Option(Int32).new(value, flag)
    when Int64
      Option(Int64).new(value, flag)
    when Float32
      Option(Float32).new(value, flag)
    when Float64
      Option(Float64).new(value, flag)
    when Bool
      Option(Bool).new(value, flag)
    else
      Option(Nil).new(value, flag)
    end
  end
end
