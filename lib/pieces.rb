require_relative 'modules.rb'

class Piece
  include InterClassMethods

  attr_accessor :symbol, :color, :range, :directions
  def initialize(color = nil)
  @color = color
  end

  def to_json(options={})
    hash = {}
    instance_variables.each do |var|
      if var == :@symbol 
        hash[var] = self.class.to_s.downcase
      else
      hash[var] = instance_variable_get(var)
    end
  end
    hash
  end

  def valid_move?(start,destination,table)
   return true if destination_valid?(start , destination, table) && path_available?(start,destination,table)
   false
  end

  def path_available?(start,destination,table)

    if self.instance_of?(Knight)
      knight_moves(start, destination, table)
    else
      pave_path(start, destination, table)
    end
  end

  def capture_pawn_directions(destination,table)
    return [[0,-1],[0,1]] if destination_is_en_passant?(destination,table)
    return [[1,1],[1,-1]] if self.color == 'white'
    return [[-1,1],[-1,-1]] if self.color == 'black'
  end

  def pave_path(start, destination, table )
    i,j = destination
    destination_square = table[i][j]
    x,y = start
    range = self.range
    directions = self.instance_of?(Pawn) && !destination_square.cell.nil? ? capture_pawn_directions(destination,table) : self.directions

    directions.each do | dx, dy |
      sequence = []
      (1..range).map do | i |
        new_x = x+dx*i
        new_y = y+dy*i

        if within_boundaries?(new_x,new_y)
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
        if within_boundaries?(new_x,new_y)
        square = table[new_x][new_y]
            return true if square == destination_square
          end
      end
      false
    end

    def check_sequence(sequence)
       return true if sequence.all?(nil)
    end



 def destination_valid?(start, destination, table)
  x,y = destination
  square = table[x][y].cell
  own_side = self.color
  return true if square == nil
  return false if square.color == own_side
  true
end

def change_attribute_of_piece
  self.range = 1 if self.instance_of?(Pawn)
  self.first_move = false
end

 def destination_is_en_passant?(destination,table)
    x,y = destination
   return true if table[x][y].cell.instance_of?(Pawn) && table[x][y].cell.en_passant == true
   false
 end

def pawn_made_two_square_advance(start,destination)
  i,j = destination
  return true if [i-2,j] == start
  return true if [i+2,j] == start
  false
end

end

  class Pawn < Piece
    attr_accessor :first_move, :en_passant
    def initialize(color=nil)
      @directions = color == 'white' ? [[1,0]] : [[-1,0]]
      @first_move = true
      @symbol = color == 'black' ? "\u{265F}" : "\u{2659}"
      @range = @first_move == true ? 2 : 1
      @en_passant = false
      super(color)
    end

  end

  class Bishop < Piece
    def initialize(color=nil)
      @symbol = color == 'black' ? "\u{2657}" : "\u{265D}"
      @range = 7
      @directions = [[1,1],[1,-1],[-1,1],[-1,-1]]
      super(color)

    end
  end

    class Rook < Piece
      attr_accessor :first_move
      def initialize(color=nil)
        @symbol = color == 'black' ? "\u{2656}" : "\u{265C}"
        @range = 7
        @directions = [[1,0],[-1,0],[0,1],[0,-1]]
        @first_move = true
        super(color)
      end
    end

    class Knight < Piece

      def initialize(color=nil)
        @directions = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
        @symbol = color == 'black' ? "\u{2658}" : "\u{265E}"
        super(color)

      end
      end

    class Queen < Piece
      def initialize(color=nil)
        @symbol = color == 'black' ? "\u{2655}" : "\u{265B}"
        @range = 7
        @directions = [[1,0],[-1,0],[0,1],[0,-1],[1,1],[1,-1],[-1,1],[-1,-1]]
        super(color)

      end
    end

    class King < Piece
      attr_accessor :first_move
      def initialize(color=nil)
        @symbol = color == 'black' ? "\u{2654}" : "\u{265A}"
        @range = 1
        @directions = [[1,0],[-1,0],[0,1],[0,-1],[1,1],[1,-1],[-1,1],[-1,-1]]
        @first_move = true
        super(color)

      end
    end
