class Array

  def to_h
    inject({}) { |h, t| h[t[0]] = t[1]; h }
  end

end
