class Piece
  attr_accessor :symbol, :color
  def initialize(color = nil)
  @color = color
  @range = 7
  end

  def valid_move?(start,destination,table)
    return true if destination_valid?(destination,table) && path_available?(start,destination,table)
  end

  def path_available?(start,destination,table)
    range = self.range
    empty_square = '-'
    if self.instance_of?(Knight)
      #code
    else
      pave_path(start, destination, table, range, empty_square)
    end
  end

  def pave_path(start, destination, table, range, empty_square)
    x,y = start
    i,j = destination
    destination_square = table[i][j]
    self.directions.each do | dx, dy |
      sequence = (1..range).map do | i |
        new_x = x+dx*i
        new_y = y+dy*i
        if (new_x).between?(0,7) && (new_y).between?(0,7)
         square_content = table[new_x][new_y]
          break if table[new_x][new_y] == destination_square
          square_content
        end
      end
      last = sequence.pop
      return true if sequence.all?(empty_square) && last == destination_square
    end
    false
    end


 def destination_valid?(destination,table)
  own_side = self.color
  x,y = destination
  return true if table[x][y].instance_of?(String)
  return false if table[x][y].instance_of?(King)
  return false if table[x][y].color == own_side
end

end

  class Pawn < Piece
    def initialize(color=nil)
      @directons = [[1,0],[1,1],[1,-1]]
      @first_move = true
      @range = @first_move == true ? 2 : 1
      @symbol = color == 'white' ? 'p' : 'p'
      super(color=nil)
    end
  end

  class Bishop < Piece
    def initialize(color=nil)
      @symbol = color == 'white' ? 'b' : 'b'
      super(color=nil)

    end
  end

    class Rook < Piece
      def initialize(color=nil)
        @symbol = color == 'white' ? 'r' : 'r'
        super(color=nil)
      end
    end

    class Knight < Piece
      def initialize(color=nil)
        @symbol = color == 'white' ? 'n' : 'n'
        super(color=nil)
        @directons = [[1,0][-1,0],[0,-1][0,1]]
        @range = 2

      end
      end

    class Queen < Piece
      def initialize(color=nil)
        @symbol = color == 'white' ? 'q' : 'q'
        super(color=nil)

      end
    end

    class King < Piece
      def initialize(color=nil)
        @symbol = color == 'white' ? 'k' : 'k'
        super(color=nil)
        @range = 1

      end
    end
