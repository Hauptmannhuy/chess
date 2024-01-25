class Board
  attr_accessor :grid, :move_order
  def initialize
    @grid = Array.new(8) { Array.new(8){ Square.new } }
    @move_order = true
    @check_declared = false
    place_pieces('black')
    place_pieces('white')
  end

  def place_pieces(color)
  place_first_line(color)
  place_second_line(color)
  end

  def place_first_line(color)
    y = color == 'white' ? 1 : 6
    x = 0
    pawn = Pawn.new(color)
    while x != 8 do
      @grid[y][x].cell = pawn
      x+=1
    end
  end

  def place_second_line(color)
    rook = Rook.new(color)
    bishop = Bishop.new(color)
    knight = Knight.new(color)
    queen = Queen.new(color)
    king = King.new(color)
    line = [rook, knight, bishop, queen, king, bishop, knight, rook]
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
       player_move
    end
  end

  def cover_king(color)
    king = find_king(color)
    x,y = king
   adjacency_squares = adjacency_squares_king(x,y)

  end

  def adjacency_squares_king(x_coordinate,y_coordinate)
    directions = @grid[x][y].cell.directions

  end

  def escape_check(color)
    king_initial_position = find_king(color)
    x,y = king_initial_position
    king_piece = @grid[x][y].cell
    loop do
      puts 'Select coordinate to withdraw your king!'
      destination = select_coordinate
     if king_piece.valid_move?(king_initial_position, destination, @grid)
      change_squares(king_piece,king_initial_position, destination)

       if !king_under_attack?(destination,color)
        @check_declared = false
       return
       else
        puts 'Wrong move!'
        change_squares(king_piece ,destination, king_initial_position)
       end
     end
    end
  end

  def player_move
    loop do
      puts 'Type coordinates to select a piece (For example: 2A)'
      start = select_coordinate(true)
      x,y = start
      piece = @grid[x][y].cell
      puts 'Type coordinates to select a destination (For example: 3A)'
      destination = select_coordinate
      if process_path(piece, start, destination,@grid)
        return change_squares(piece, start, destination)
      else
        puts 'Invalid move. Try again.'
      end
    end
  end

  def process_path(piece, start, destination,board)

    piece.valid_move?(start,destination,board)


  end

  def check_mate
    king_coordinates = find_king
    x,y = king_coordinates
    possible_fall_back_squares = @grid[x][y].cell.directions
    return true if !king_fall_back_possibility && !piece_cover_king
    false
  end

  def in_check?(king_color = @move_order == false ? 'black' : 'white')

    king_coordinates = find_king(king_color)
    x,y = king_coordinates
    destination = [x,y]
    if king_under_attack?(destination,king_color)
      @check_declared = true
      return true
    end
     false
  end

  def king_under_attack?(destination, king_color)
    enemy_color = king_color == 'black' ? 'white' : 'black'
    @grid.each_with_index do |row, x|
      row.each_with_index do |square,y|
        if !square.cell.nil? && square.cell.color == enemy_color && !square.cell.instance_of?(King)
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

  def change_squares(piece, start, destination)
    x,y = start
    i,j = destination
    empty_square = nil
    @grid[i][j].cell = piece
    @grid[x][y].cell = empty_square
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

end

class Square
  attr_accessor :cell
  def initialize
    @cell = nil
  end
end
