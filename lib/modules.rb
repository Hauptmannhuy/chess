module InterClassMethods

  def within_boundaries?(x_coordinate,y_coordinate)
    return true if (x_coordinate).between?(0,7) && (y_coordinate).between?(0,7)
    false
  end



end

class Array
  def each_square
    self.each_with_index do |row, x|
      row.each_with_index do |cell, y|
        yield x,y,cell
    end
  end
end
 end
