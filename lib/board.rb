class Board
  attr_accessor :grid
  def initialize
    @grid = Array.new(8) { Array.new(8, '-') }
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
      @grid[y][x] = pawn
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
    @grid[y] = line
  end


  def display
    array = []
    num = 1
    @grid.each do |row|
      i = 0
      part = []
      part << num
      num+=1
      row.each do |piece|
        part << piece.symbol if piece != '-' && !piece.instance_of?(Integer)
        part << piece if piece == '-'
        array << part if i == 7
        i+=1
      end
    end
   array.each do |row|
     puts row.join(' ')
   end
    puts ['*',*('a'..'h')].join(' ').upcase
  end

  def player_move
    loop do
    puts 'Type coordinates to select a piece (For example: 2A)'
    start = select_coordinate
    x,y = start
    piece = @grid[x][y]
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

  def change_squares(piece, start, destination)
    x,y = start
    i,j = destination
    empty_square = '-'
    @grid[i][j] = piece
    @grid[x][y] = empty_square
  end




  def select_coordinate
    loop do
    input = gets.chomp.downcase.split('')
    verified_coordinates = verify_coordinates(input)
   return translated_coordinates = translate_coordinates(verified_coordinates)
  end
  end

  def translate_coordinates(input)
    arr = ('a'..'h').to_a
    x,y = input
    [x.to_i - 1, arr.index(y) + 1]

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
