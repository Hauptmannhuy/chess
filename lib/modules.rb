module InterClassMethods

  def within_boundaries?(x_coordinate,y_coordinate)
    return true if (x_coordinate).between?(0,7) && (y_coordinate).between?(0,7)
    false
  end


end
