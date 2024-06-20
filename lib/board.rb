require_relative 'modules.rb'

class Board

include InterClassMethods

  attr_accessor :grid, :move_order, :check_declared, :en_passant_queue
  def initialize
    @grid = Array.new(8) { Array.new(8){ Square.new } }
    @move_order = false
    @check_declared = false
    @en_passant_queue = []
  end

  def load_pieces(board)
    deser_grid = board['@board']['@grid']
    deser_grid.each_with_index do |row,x|
      row.each_with_index do |square,y|
        if square['@cell'] != 'null'
          obj = square['@cell']
          piece = obj['@symbol']
          color = obj['@color']
          if obj['@symbol'] == 'pawn' || obj['@symbol'] == 'king'
            special = obj['@symbol'] == 'pawn' ? obj['@en_passant'] : obj['@first_move']
          end
          @grid[x][y].cell = load_piece(piece,color,special)
        end
      end
    end
  end

  def load_instances(parameters)
    @move_order = parameters['@board']['@move_order'] == 'false' ? false : true
    @check_declared = parameters['@board']['@check_declared'] == 'false' ? false : true
    load_pieces(parameters)
    load_en_passant(parameters['@board']['@en_passant_queue'])
  end

  def load_piece(piece,color,special = nil)
    case piece
    when 'pawn' then piece = Pawn.new(color)
    when 'bishop' then piece = Bishop.new(color)
    when 'rook' then piece = Rook.new(color)
    when 'queen' then piece = Queen.new(color)
    when 'knight' then piece = Knight.new(color)
    when 'king' then piece = King.new(color)
    end
      piece.en_passant = special if piece.class == Pawn
      piece.first_move = special if piece.class == King
      piece
  end

  def find_en_passant_positions
    arr = []
    queue = @en_passant_queue.dup
    until queue.empty? do
      object = queue.shift
      @grid.each_with_index do |row,x|
        row.each_with_index do |square,y|
          if square.cell == object
            arr << [x,y]
          end
        end
      end
    end
    arr
  end

  def load_en_passant(queue)
    queue = JSON.load(queue)
    while !queue.empty?
        coord = queue.shift
      @grid.each_with_index do |row,x|
        row.each_with_index do |square,y|
          if coord == [x,y]
            @en_passant_queue << square.cell
          end
        end
      end
    end
  end

  def to_json(options ={})
    hash = {}
    self.instance_variables.each do |var|
      if var == :@en_passant_queue && !@en_passant_queue.empty?
        hash[var] = find_en_passant_positions.to_json
      else
        hash[var] = instance_variable_get(var).to_json
      end
    end
     hash.to_json
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
    array.reverse.each do |row|
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


  def choose_coordinates
      puts 'Type coordinates to select a piece (For example: 2A)'
      start = select_coordinate(true)
      puts 'Type coordinates to select a destination (For example: 3A)'
      destination = select_coordinate
      return indetify_move(start,destination)
end

  def indetify_move(start,destination)
    return castling_move(start,destination) if castling_move_identified?(start,destination)
    standard_move(start,destination)
  end

  def standard_move(start,destination)
      x,y = start
      piece = @grid[x][y].cell
      if move_valid?(piece,start,destination)
        piece.change_attribute_of_piece if piece_first_move?(piece)
        return complete_turn(@grid,piece,start,destination)
      else
        puts 'Invalid move. Try again.'
        return choose_coordinates
    end
  end

  def complete_turn(board,piece,start,destination)
    if promotion_possible?(piece,destination)
      promote_pawn(start,destination,board,piece.color)
    elsif pawn_moved_two_squares?(piece,start,destination)
      en_passant_enqueue(piece)
      change_board(@grid,piece, start, destination)
    elsif pawn_taken_as_en_passant?(piece,board,start,destination)
      en_passant_change_board(@grid,piece,start,destination)
    else
      change_board(@grid,piece, start, destination)
    end
  end

  def promotion_possible?(piece,destination)
    piece.instance_of?(Pawn) && (destination[0] == 0 || destination[0] == 7)
  end

  def pawn_moved_two_squares?(piece,start,destination)
    piece.instance_of?(Pawn) && piece.pawn_made_two_square_advance(start,destination)
  end

  def pawn_taken_as_en_passant?(piece,board,start,destination)
    piece.instance_of?(Pawn) && (!board[destination[0]][destination[1]].cell.nil? && board[destination[0]][destination[1]].cell.en_passant == true ) && start[0] == destination[0]
  end

  def promote_pawn(start,destination,board,color)
    input = promotion_promt
    promotion_piece = nil
    case input
    in 1 then promotion_piece = Queen.new(color)
    in 2 then promotion_piece = Rook.new(color)
    in 3 then promotion_piece = Bishop.new(color)
    in 4 then promotion_piece = Knight.new(color)
    end
    change_board(board,promotion_piece,start,destination)
  end

  def promotion_promt
    puts "You can promote your pawn!\n What shall it be?\n Print number to choose"
    puts "1:Queen\n2:Rook\n3:Bishop\n4:Knight"
    loop do
    input = gets.chomp.to_i
    return input if input.between?(1,4)
    puts 'Wrong number!'
    end
  end

  def piece_first_move?(piece)
    if piece.instance_of?(Pawn) || piece.instance_of?(Rook) || piece.instance_of?(King)
      return true if piece.first_move == true
    end
    false
  end

  def castling_move(start, destination)
    x,y = start
    i,j = destination
    start_piece = @grid[x][y].cell
    rook_piece = @grid[i][j].cell
    if castling_move_possible?(start,destination,start_piece.color)
     castling_square(start_piece,start,destination,rook_piece)
    else
      puts 'Invalid move. Try again.'
      choose_coordinates
    end
  end

  def castling_move_possible?(start,destination,color)
    return false if !pieces_meet_castling_criteria?(start,destination)
    if castling_move_legit?(start,destination) && !square_under_enemy_attack?(start,color,@grid)
      return true
    end
    false
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
    start_piece.first_move = false
    rook_piece.first_move = false
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
      return false if square_under_enemy_attack?(square,color,@grid)
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


  def escape_check(color)
    loop do
      puts 'Your king in check!'
      puts 'Type coordinates to select a piece (For example: 2A)'
      start = select_coordinate(true)
      x,y = start
      start_piece = @grid[x][y].cell
      puts 'Type coordinates to select a destination (For example: 3A)'
      destination = select_coordinate
      if move_valid?(start_piece,start,destination)
        change_board(@grid,start_piece,start,destination)
        @check_declared = false
       return
       else
        puts 'Wrong move!'
     end
    end
  end


  def check_mate(color = @move_order == false ? 'black' : 'white')
    return true if !piece_defend_king_possible?(color) && !king_escape_possible?(color)
    false
  end

  def in_check?(team_color = @move_order == false ? 'black' : 'white')

    king_coordinates = find_king(team_color)
    x,y = king_coordinates
    destination = [x,y]
    if square_under_enemy_attack?(destination,team_color,@grid)
      @check_declared = true
      return true
    end
     false
  end

  def is_stalemate?
    color = @move_order == false ? 'white' : 'black'
    @grid.each_with_index do |row,x|
      row.each_with_index do |square,y|
        current_piece = @grid[x][y].cell
        if !current_piece.nil? && current_piece.color == color
          start = [x,y]
          return false if piece_can_move?(current_piece, start)
        end
      end
    end
    true
  end

  def piece_can_move?(piece, start)
    x,y = start
    directions = piece.directions
    directions.each do |dx,dy|
      new_x = dx+x
      new_y = dy+y
      next if !within_boundaries?(new_x,new_y)
      destination = [new_x,new_y]
      destination_piece = @grid[new_x][new_y]
      return true if move_valid?(piece,start,destination)
    end
    false
  end


def move_valid?(piece,start,destination)
  table = copy_grid
  x,y = start
  i,j = destination
  if piece.valid_move?(start,destination,table)
    return false if move_exposed_king?(piece,start,destination,table)
    true
    else
      false
  end
end

def copy_grid
  new_grid = Array.new(8) { Array.new(8) }

  @grid.each_with_index do |row, i|
    row.each_with_index do |square, j|
      new_grid[i][j] = square.dup
    end
  end
  new_grid
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
          if move_valid?(piece,start,destination)
            return true if king_safe?(color,start,destination,piece)
          end
        end
      end
    end
    false
  end


  def king_safe?(color,start,destination,piece)
    x,y = destination
    table = copy_grid
    change_board(table,piece,start,destination)
    king = find_king(color,table)
    if square_under_enemy_attack?(king,color,table)
      false
    else
      true
    end

  end


  def move_exposed_king?(piece,start,destination,table)
    change_board(table,piece,start,destination)
    king_coords = find_king(piece.color,table)
    return true if square_under_enemy_attack?(king_coords, piece.color,table)
    false
 end

 def square_under_enemy_attack?(destination, team_color, table)
  enemy_color = team_color == 'black' ? 'white' : 'black'
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


  def find_king(color, table = @grid)
    table.each_with_index do |row, x|
      row.each_with_index do |square,y|
      return [x,y]  if square.cell.instance_of?(King) && square.cell.color == color
      end
    end

  end

  def change_board(table,piece, start, destination)
    x,y = start
    i,j = destination
    table[i][j].cell = piece
    table[x][y].cell = nil
  end

  def en_passant_change_board(table,piece,start,destination)
    x,y = start
    i,j = destination
    table[x][y].cell = nil
    table[i][j].cell = nil
    table[i+1][j].cell = piece if piece.color == 'white'
    table[i-1][j].cell = piece if piece.color == 'black'

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

  def en_passant_enqueue(piece)
    piece.en_passant = true
    @en_passant_queue.unshift(piece)
  end

  def en_passant_dequeue
    @en_passant_queue.last.en_passant = false
    @en_passant_queue.pop
  end

end

class Square
  attr_accessor :cell
  def initialize
    @cell = nil
  end

  def to_json(options = {})
    hash = {}
    instance_variables.each do |var|
      hash[var] = instance_variable_get(var).to_json
    end
    hash.to_json
  end
end
