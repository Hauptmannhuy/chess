class Piece
  attr_accessor :symbol, :color, :range, :directions
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
    table[i][j] = 'destination'
    destination_square = table[i][j]
    sequence = []

    self.directions.each do | dx, dy |
      sequence = (1..range).map do | i |
        new_x = x+dx*i
        new_y = y+dy*i

        if (new_x).between?(0,7) && (new_y).between?(0,7)
         square_content = table[new_x][new_y]
         square_content

         if square_content == 'destination'
           return true if check_sequence(sequence, empty_square)
         end

        end

      end
    end
    false
    end

    def check_sequence(sequence, empty_square)
      p sequence
       return true if sequence.all?(empty_square)
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
      @directions = [[1,0],[1,1],[1,-1]]
      @first_move = true
      @symbol = color == 'white' ? 'p' : 'p'
      super(color)
      @range = @first_move == true ? 2 : 1
    end
  end

  class Bishop < Piece
    def initialize(color=nil)
      @symbol = color == 'white' ? 'b' : 'b'
      super(color)

    end
  end

    class Rook < Piece
      def initialize(color=nil)
        @symbol = color == 'white' ? 'r' : 'r'
        super(color)
      end
    end

    class Knight < Piece
      def initialize(color=nil)
        @symbol = color == 'white' ? 'n' : 'n'
        super(color)
        @directions = [[1,0][-1,0],[0,-1][0,1]]
        @range = 2

      end
      end

    class Queen < Piece
      def initialize(color=nil)
        @symbol = color == 'white' ? 'q' : 'q'
        super(color)

      end
    end

    class King < Piece
      def initialize(color=nil)
        @symbol = color == 'white' ? 'k' : 'k'
        super(color)
        @range = 1

      end
    end
