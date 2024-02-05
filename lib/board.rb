class Board
  attr_accessor :grid, :move_order
  def initialize
    @grid = Array.new(8) { Array.new(8){ Square.new } }
    @move_order = false
    @check_declared = false
  end


  def place_pieces(color)
  place_first_line(color)
  place_second_line(color)
  end

  def place_first_line(color)
    y = color == 'white' ? 1 : 6
    x = 0
    while x != 8 do
      pawn = Pawn.new(color)
      @grid[y][x].cell = pawn
      x+=1
    end
  end

  def place_second_line(color)
    rook_1 = Rook.new(color)
    rook_2 = Rook.new(color)
    bishop_1 = Bishop.new(color)
    bishop_2 = Bishop.new(color)
    knight_1 = Knight.new(color)
    knight_2 = Knight.new(color)
    queen = Queen.new(color)
    king = King.new(color)
    line = [rook_1, knight_1, bishop_1, queen, king, bishop_2, knight_2, rook_2]
    y = color == 'white' ? 0 : 7
    8.times{|i| @grid[y][i].cell = line[i]}
  end



  def display
    array = []
    n = 1
    @grid.each do |row|
      i = 0
      part = []
      part << n
      n+=1
      row.each do |piece|
        part << '-' if piece.cell == nil
        part << piece.cell.symbol if piece.cell != nil && piece.cell != '-'
        array << part if i == 7
        i+=1
      end
    end
    array.each do |row|
      puts row.join(' ')
    end
    puts ['*',*('a'..'h')].join(' ').upcase
  end

  def play_round
    if @check_declared == true && @move_order == false
      escape_check('white')
    elsif @check_declared == true && @move_order == true
       escape_check('black')
    else
       choose_coordinates
    end
  end


  def escape_check(color)
    loop do
      puts 'Type coordinates to select a piece (For example: 2A)'
      start = select_coordinate(true)
      x,y = start
      start_piece = @grid[x][y].cell
      puts 'Type coordinates to select a destination (For example: 3A)'
      destination = select_coordinate
      if start_piece.valid_move?(start, destination, @grid)
        change_squares(start_piece,start, destination)
        king_coords = find_king(color)
        if !square_under_enemy_attack?(king_coords,color)
        @check_declared = false
       return
       else
        puts 'Wrong move!'
        change_squares(start_piece ,destination, start)
       end
     end
    end
  end

  def choose_coordinates
      puts 'Type coordinates to select a piece (For example: 2A)'
      start = select_coordinate(true)
      puts 'Type coordinates to select a destination (For example: 3A)'
      destination = select_coordinate
      return indetify_move(start,destination)
end

  def indetify_move(start,destination)
    return castling_move if castling_move_identified?(start,destination)
    standard_move(start,destination)
  end

  def standard_move(start,destination)
      x,y = start
      piece = @grid[x][y].cell
      if process_path(piece, start, destination,@grid)
        piece.change_attribute_of_piece if piece_first_move?(piece)
        return change_squares(piece, start, destination)
      else
        puts 'Invalid move. Try again.'
        return choose_coordinates
    end
  end

  def piece_first_move?(piece)
    if piece.instance_of?(Pawn) || piece.instance_of?(Rook) || piece.instance_of?(King)
      return true if piece.first == true
    end
    false
  end

  def castling_move(start, destination)
    x,y = start
    i,j = destination
    start_piece = @grid[x][y].cell
    rook_piece = @grid[i][j].cell
    if pieces_meet_castling_criteria?(start,destination) && castling_move_legit?(start,destination) && !square_under_enemy_attack?(start, start_piece.color)
     castling_square(start_piece,start,destination,rook_piece)
    else
      puts 'Invalid move. Try again.'
      choose_coordinates
    end
  end

  def castling_square(start_piece,start,destination,rook_piece)
    i,j = destination
    x,y = start
    @grid[x][y].cell = nil
    @grid[i][j].cell = nil
    if j == 0
      new_position_rook = [i,j+y-1]
      new_position_king = [x,y-2]
    else
      new_position_rook = [i,j-2]
      new_position_king = [x,y+2]
    end
    @grid[new_position_king[0]][new_position_king[1]].cell = start_piece
    @grid[new_position_rook[0]][new_position_rook[1]].cell = rook_piece
  end

  def pieces_meet_castling_criteria?(start, destination)
      i,j = destination
      x,y = start
      start_position = @grid[x][y].cell
      destination_position = @grid[i][j].cell
      return true if (start_position.instance_of?(King) && start_position.first_move == true) && (destination_position.instance_of?(Rook) && destination_position.first_move == true)
      false
  end


  def castling_move_legit?(start,destination)
    color = @grid[start[0]][start[1]].cell.color
    squares = extract_castling_path(start,destination)
    return false if !check_castling_path(squares)
    squares.each do |square|
      return false if square_under_enemy_attack?(square,color)
    end
    true
  end

  def check_castling_path(squares)
    return false if squares.any?{|x,y| @grid[x][y].cell != nil }
    true
  end


  def extract_castling_path(start,destination)
    x,y = start
    column = destination[1]
    if @grid[x][y].cell.color == 'white'
      case column
      in 0 then [[0,1],[0,2],[0,3]]
      in 7 then [[0,5],[0,6]]
      end
      else
      case column
      in 0 then [[7,1],[7,2],[7,3]]
      in 7 then [[7,5],[7,6]]
      end
      end
  end


  def castling_move_identified?(start,destination)
    x,y = start
    i,j = destination
    start_piece = @grid[x][y].cell
    rook_piece = @grid[i][j].cell
    friendly_color = start_piece.color
    return true if start_piece.instance_of?(King) && (rook_piece.instance_of?(Rook) && rook_piece.color == friendly_color)
    false
  end

  def process_path(piece, start, destination,board)
    piece.valid_move?(start,destination,board)
  end

  def within_boundaries?(x_coordinate,y_coordinate)
    return true if (x_coordinate).between?(0,7) && (y_coordinate).between?(0,7)
    false
  end


  def king_escape_possible?(color = @move_order == false ? 'black' : 'white')
    king = find_king(color)
    x,y = king
    adjacency_squares = adjacency_squares_king(x,y,color)
    return false if adjacency_squares.empty?
    adjacency_squares.each do |dx,dy|
      square = @grid[dx][dy]
      if square.cell.nil? || square.cell.color != color
        destination = [dx,dy]
        start = [x,y]
        piece = @grid[x][y].cell
          return true if king_safe?(color,start,destination,piece)
         end
      end
    false
  end


  def piece_defend_king_possible?(color = @move_order == false ? 'black' : 'white')
    king = find_king(color)
    x,y = king
    vulnerable_directions = possible_directions(x,y)
    return false if vulnerable_directions.nil?
    vulnerable_directions.each do |dx,dy|
      destination = [dx,dy]
      return true if process_piece_defence_king(color,destination)
    end
    false
  end

  def process_piece_defence_king(color,destination)
    @grid.each_with_index do |row,x|
      row.each_with_index do |square, y|
        if !square.cell.nil? && square.cell.color == color && !square.cell.instance_of?(King)
          start = [x,y]
          piece = square.cell
          if piece.valid_move?(start,destination,@grid)
            return true if king_safe?(color,start,destination,piece)
          end
        end
      end
    end
    false
  end


  def possible_directions(x,y)
    start_piece = @grid[x][y].cell
    king_coordinate = [x,y]
    directions = start_piece.directions
    sequences = []
    directions.each do | dx, dy |
      squares_iterated = iterate_squares(dx,dy,start_piece,king_coordinate)
      sequences << squares_iterated
    end
    knight_directions = knight_directions(king_coordinate)
   sequences.compact.flatten(1).concat(knight_directions)
  end

  def iterate_squares(dx,dy,king,king_coordinate)
    x,y = king_coordinate
    sequence = []
    (1..7).each do |step|
      new_x = x+dx*step
      new_y = y+dy*step
      if within_boundaries?(new_x,new_y)
        square = @grid[new_x][new_y]
        return nil if !square.cell.nil? && square.cell.color == king.color
        if !square.cell.nil? && square.cell.color != king.color
          sequence << [new_x,new_y]
          return sequence
        end
        sequence << [new_x,new_y]
      end
    end
    nil
  end

  def knight_directions(king_coords)
    array = []
    x,y = king_coords
    knight_coords = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
    knight_coords.each do |dx, dy|
      new_x = x+dx
      new_y = y+dy
      if within_boundaries?(new_x,new_y)
        array << [new_x,new_y]
      end
    end
    array
  end

  def king_safe?(color,start,destination,piece)
    x,y = destination
    replacing_square = @grid[x][y].cell
    change_squares(piece,start,destination)
    if !in_check?(color)
      change_squares(piece,destination,start,replacing_square)
      true
    else
      change_squares(piece,destination,start,replacing_square)
      false
    end

  end

  def adjacency_squares_king(x_coordinate,y_coordinate,color)
    array = []
    directions = @grid[x_coordinate][y_coordinate].cell.directions
    directions.each do |dx,dy|
      new_x = x_coordinate+dx
      new_y = y_coordinate+dy
      if within_boundaries?(new_x,new_y)
        square = @grid[new_x][new_y]
       array << [new_x,new_y] if square.cell.nil? || (!square.cell.nil? && color != square.cell.color)
      end
    end
    array
  end

  def check_mate(color = @move_order == false ? 'black' : 'white')
    return true if !piece_defend_king_possible?(color) && !king_escape_possible?(color)
    false
  end

  def in_check?(king_color = @move_order == false ? 'black' : 'white')

    king_coordinates = find_king(king_color)
    x,y = king_coordinates
    destination = [x,y]
    if square_under_enemy_attack?(destination,king_color)
      @check_declared = true
      return true
    end
     false
  end

  def square_under_enemy_attack?(destination, king_color)
    enemy_color = king_color == 'black' ? 'white' : 'black'
    @grid.each_with_index do |row, x|
      row.each_with_index do |square,y|
        if !square.cell.nil? && square.cell.color == enemy_color
          start = [x,y]
          piece = square.cell
         return true if piece.valid_move?(start,destination,@grid)
        end
      end
    end
    false
  end

  def find_king(color)
    @grid.each_with_index do |row, x|
      row.each_with_index do |square,y|
      return [x,y]  if square.cell.instance_of?(King) && square.cell.color == color
      end
    end

  end

  def change_squares(piece, start, destination, square_to_replace = nil)
    x,y = start
    i,j = destination
    @grid[i][j].cell = piece
    @grid[x][y].cell = square_to_replace
  end


  def move_turn_order
    @move_order = @move_order == false ? true : false

  end


  def select_coordinate(start_coordinate = false)
    loop do
    input = gets.chomp.downcase.split('')
    verified_coordinates = verify_coordinates(input)
    translated_coordinates = translate_coordinates(verified_coordinates)
    if start_coordinate == false
      return translated_coordinates
    else
      is_square_nil = square_not_nil?(translated_coordinates)
      color_correspond = color_correspond_piece?(translated_coordinates)
      return translated_coordinates if is_square_nil && color_correspond
    end
  end
  end

  def color_correspond_piece?(piece)
    x,y = piece
    piece_color = @grid[x][y].cell.color if !@grid[x][y].cell.nil?
    if (@move_order == false && piece_color == 'white') || (@move_order == true && piece_color == 'black')
      return true
    else
      puts 'You can only choose piece of your own color team!'
      false
    end
  end

  def square_not_nil?(input)
    x,y = input
    square = @grid[x][y].cell
    if square.nil?
      puts 'You cannot select empty square as start point!'
      return false
    else
    true
    end
  end

  def translate_coordinates(input)
    arr = ('a'..'h').to_a
    x,y = input
    [x.to_i-1, arr.index(y)]

  end

  def verify_coordinates(input)
    loop do
      x,y = input
      return input if y.between?('a','h')
      puts 'Error! Select correct value.'
      input = gets.chomp.downcase.split('')
    end
  end

#   def clean_board
#     @grid.each_with_index do |row,x|
#       row.each_with_index do |square,y|
#         square.cell = nil
#       end
#     end
# end

end

class Square
  attr_accessor :cell
  def initialize
    @cell = nil
  end
end
