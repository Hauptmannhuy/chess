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
    directions = self.directions
    if self.instance_of?(Knight)
      knight_moves(start, destination, table)
    else
      x,y = destination
      destination_square = table[x][y]
      directions = capture_pawn_directions if self.instance_of?(Pawn) && destination_square.cell != nil
     pave_path(start, destination, destination_square, table, directions)
    end
  end

  def capture_pawn_directions
    return [[1,1],[1,-1]] if self.color == 'white'
    return [[-1,1],[-1,-1]] if self.color == 'black'
  end

  def pave_path(start, destination,destination_square, table, directions )
    x,y = start
    i,j = destination

    directions.each do | dx, dy |
      sequence = []
      (1..range).map do | i |
        new_x = x+dx*i
        new_y = y+dy*i

        if (new_x).between?(0,7) && (new_y).between?(0,7)
         current_square = table[new_x][new_y]
         if current_square == destination_square
          return true if check_sequence(sequence)
        end
       sequence << current_square.cell
        end

      end
    end
    false
    end

    def knight_moves(start,destination, table)
      x,y = start
      i,j = destination
      destination_square = table[i][j]

      self.directions.each do | dx, dy |
        new_x = x+dx
        new_y = y+dy
        if (x+dx).between?(0,7) && (y+dy).between?(0,7)
        square = table[new_x][new_y]
            return true if square == destination_square
          end
      end
      false
    end

    def check_sequence(sequence)
       return true if sequence.all?(nil)
    end

 def destination_valid?(destination,table)
  x,y = destination
  square = table[x][y].cell
  own_side = self.color
  return true if square == nil
  return false if square.instance_of?(King)
  return false if square.color == own_side
  true
end

end

  class Pawn < Piece
    def initialize(color=nil)
      @directions = color == 'white' ? [[1,0]] : [[-1,0]]
      @first_move = true
      @symbol = color == 'white' ? 'p' : 'p'
      super(color)
      @range = @first_move == true ? 2 : 1
    end
  end

  class Bishop < Piece
    def initialize(color=nil)
      @symbol = color == 'white' ? 'b' : 'b'
      @range = 7
      @directions = [[1,1],[1,-1],[-1,1],[-1,-1]]
      super(color)

    end
  end

    class Rook < Piece
      def initialize(color=nil)
        @symbol = color == 'white' ? 'r' : 'r'
        @range = 7
        @directions = [[1,0],[-1,0],[0,1],[0,-1]]
        super(color)
      end
    end

    class Knight < Piece
      def initialize(color=nil)
        @directions = [[2,1],[2,-1],[-1,-2],[1,-2],[-2,-1],[-2,1],[1,2],[-1,2]]
        @symbol = color == 'white' ? 'n' : 'n'
        super(color)

      end
      end

    class Queen < Piece
      def initialize(color=nil)
        @symbol = color == 'white' ? 'q' : 'q'
        @range = 7
        @directions = [[1,0],[-1,0],[0,1],[0,-1],[1,1],[1,-1],[-1,1],[-1,-1]]
        super(color)

      end
    end

    class King < Piece
      def initialize(color=nil)
        @symbol = color == 'white' ? 'k' : 'k'
        @range = 1
        @directions = [[1,0],[-1,0],[0,1],[0,-1],[1,1],[1,-1],[-1,1],[-1,-1]]
        super(color)

      end
    end
