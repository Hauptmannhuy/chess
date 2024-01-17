class Piece
  attr_accessor :symbol, :color
  def initialize(color = nil)
  @color = color
  end
end

  class Pawn < Piece 
    def initialize(color=nil)
      @first_move = true
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

      end
    end