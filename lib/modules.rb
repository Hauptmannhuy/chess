module InterClassSquareMethods

  def king_moving_into_square_under_attack?(piece,destination,table)
    return true if piece.instance_of?(King) && square_under_enemy_attack?(destination, piece.color,table)
     false
   end

   def square_under_enemy_attack?(destination, king_color, table)
    enemy_color = king_color == 'black' ? 'white' : 'black'
    table.each_with_index do |row, x|
      row.each_with_index do |square,y|
        if !square.cell.nil? && square.cell.color == enemy_color
          start = [x,y]
          piece = square.cell
         return true if piece.valid_move?(start,destination,table)
        end
      end
    end
    false
  end

   def within_boundaries?(x_coordinate,y_coordinate)
    return true if (x_coordinate).between?(0,7) && (y_coordinate).between?(0,7)
    false
  end


end
