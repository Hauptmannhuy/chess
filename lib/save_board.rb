module SaveBoard
  def load_pieces(board)
    deser_grid = board['@board']['@grid']
    deser_grid.each_square do |x, y, square|
      next unless square['@cell'] != 'null'

      obj = square['@cell']
      piece = obj['@symbol']
      color = obj['@color']
      if obj['@symbol'] == 'pawn' || obj['@symbol'] == 'king'
        special = obj['@symbol'] == 'pawn' ? obj['@en_passant'] : obj['@first_move']
      end
      @grid[x][y].cell = load_piece(piece, color, special)
    end
  end

  def load_instances(parameters)
    @move_order = !(parameters['@board']['@move_order'] == 'false')
    @check_declared = !(parameters['@board']['@check_declared'] == 'false')
    load_pieces(parameters)
    load_en_passant(parameters['@board']['@en_passant_queue'])
  end

  def load_piece(piece, color, special = nil)
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
    until queue.empty?
      object = queue.shift
      @grid.each_square do |x, y, square|
        arr << [x, y] if square.cell == object
      end
    end
    arr
  end

  def load_en_passant(queue)
    queue = JSON.load(queue)
    until queue.empty?
      coord = queue.shift
      @grid.each_square do |x, y, square|
        @en_passant_queue << square.cell if coord == [x, y]
      end
    end
  end

  def to_json(_options = {})
    hash = {}
    instance_variables.each do |var|
      hash[var] = if var == :@en_passant_queue && !@en_passant_queue.empty?
                    find_en_passant_positions.to_json
                  else
                    instance_variable_get(var).to_json
                  end
    end
    hash.to_json
  end
end
