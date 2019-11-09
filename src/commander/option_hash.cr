class OptionHash(T1, T2) < Hash(T1, T2)
  def [](key)
    super.value
  end

  def delete(key)
    result = super
    result.value unless result.nil?
  end
end
