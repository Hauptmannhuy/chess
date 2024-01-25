require_relative '../lib/board.rb'
require_relative '../lib/pieces.rb'

describe Piece do
  board = Board.new
  table =  board.instance_variable_get(:@grid)
 describe '#valid_move?' do

  describe "pawn movement" do
    context 'when pawn moves one step forward from 2A to 3A' do
      piece = table[1][0].cell
      start = [1,0]
      destination = [2,0]
      it 'returns true' do
        expect(piece.valid_move?(start,destination,table)).to eq(true)
      end
    end
    context 'when white pawn takes enemy piece' do
      piece = Pawn.new('white')
      table[5][0] = piece
      start = [5,0]
      destination = [6,1]
      it 'returns true' do
        expect(piece.valid_move?(start,destination,table)).to eq(true)
      end
    end
  end
  end
end

describe Board do
  subject(:board){ described_class.new }
  describe '#in_check?' do


  context 'when king in danger of attack by pawn' do
    before do
    table = board.instance_variable_get(:@grid)
    table.each_with_index do |row,x|
      row.each_with_index do |square,y|
        square.cell = nil
      end
    end
    black_pawn = Pawn.new('black')
    white_king = King.new('white')
    table[2][2].cell = white_king
    table[3][3].cell = black_pawn
    table[3][3].cell.range = 1
    board.instance_variable_set(:@grid, table)
  end
    it 'returns true' do
      expect(board.in_check?('white')).to eq(true)
      end
    end
    context 'when king is in danger of attack by rook' do
      before do
        table = board.instance_variable_get(:@grid)
        table.each_with_index do |row,x|
          row.each_with_index do |square,y|
            square.cell = nil
          end
        end
        black_rook = Rook.new('black')
        white_king = King.new('white')
        table[3][3].cell = white_king
        table[7][3].cell = black_rook
        board.instance_variable_set(:@grid, table)
      end
        it 'returns true' do
          expect(board.in_check?('white')).to eq(true)
        end
  end
    context "when king is in danger of attack by knight" do
      before do
        table = board.instance_variable_get(:@grid)
        table.each_with_index do |row,x|
          row.each_with_index do |square,y|
            square.cell = nil
          end
        end
        black_knight = Knight.new('black')
        white_king = King.new('white')
        table[3][3].cell = white_king
        table[1][2].cell = black_knight
        board.instance_variable_set(:@grid, table)
      end
        it 'returns true' do
          expect(board.in_check?('white')).to eq(true)
        end
    end
    context "when king is in danger of attack by bishop" do
      before do
        table = board.instance_variable_get(:@grid)
        table.each_with_index do |row,x|
          row.each_with_index do |square,y|
            square.cell = nil
          end
        end
        white_bishop = Bishop.new('black')
        white_king = King.new('white')
        table[3][3].cell = white_king
        table[7][7].cell = white_bishop
        board.instance_variable_set(:@grid, table)
      end
        it 'returns true' do
          expect(board.in_check?('white')).to eq(true)
        end
    end
    context 'when king is in danger of attack by queen' do
      before do
        table = board.instance_variable_get(:@grid)
        table.each_with_index do |row,x|
          row.each_with_index do |square,y|
            square.cell = nil
          end
        end
        white_queen = Queen.new('black')
        white_king = King.new('white')
        table[3][3].cell = white_king
        table[7][7].cell = white_queen
        board.instance_variable_set(:@grid, table)
      end
        it 'returns true' do
          expect(board.in_check?('white')).to eq(true)
        end
    end
    end

    describe "#escape_check" do
    context 'when king is in check in user trying escape to wrong coordinate and then to correct coordinate' do
      before do
        table = board.instance_variable_get(:@grid)
        table.each_with_index do |row,x|
          row.each_with_index do |square,y|
            square.cell = nil
          end
        end
        white_queen = Queen.new('white')
        black_king = King.new('black')
        table[3][3].cell = black_king
        table[7][7].cell = white_queen
        board.instance_variable_set(:@grid, table)
        allow(board).to receive(:puts)
        allow(board).to receive(:select_coordinate).and_return([4,3])
        allow(board).to receive(:find_king).and_return([3,3])
      end
      xit 'prints error message and then receives #change_squares' do


      board.escape_check
    end
  end
end
end
