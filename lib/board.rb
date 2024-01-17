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
        part << piece.symbol if piece != '-'
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

  def move(piece, start, finish)
    
    

  end

end