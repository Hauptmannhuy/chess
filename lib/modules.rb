module InterClassSquareMethods

  def king_moved_into_square_under_attack?(piece,start,destination,table)
    if piece.instance_of?(King)
      change_board(table,piece,start,destination)
      return true if square_under_enemy_attack?(destination, piece.color,table)
    else
      false
    end
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
