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
    white_pawn = Pawn.new('white')
    black_king = King.new('black')
    table[3][3].cell = black_king
    table[1][3].cell = white_pawn
    table[1][3].cell.range = 1
    board.instance_variable_set(:@grid, table)
  end
    it 'returns check' do
      expect(board.in_check?).to eq('check')
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
        white_rook = Rook.new('white')
        black_king = King.new('black')
        table[3][3].cell = black_king
        table[7][3].cell = white_rook
        board.instance_variable_set(:@grid, table)
      end
        it 'returns check' do
          expect(board.in_check?).to eq('check')
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
        white_knight = Knight.new('white')
        black_king = King.new('black')
        table[3][3].cell = black_king
        table[6][1].cell = white_knight
        board.instance_variable_set(:@grid, table)
      end
        it 'returns check' do
          expect(board.in_check?).to eq('check')
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
        white_bishop = Bishop.new('white')
        black_king = King.new('black')
        table[3][3].cell = black_king
        table[7][7].cell = white_bishop
        board.instance_variable_set(:@grid, table)
      end
        it 'returns check' do
          expect(board.in_check?).to eq('check')
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
        white_queen = Queen.new('white')
        black_king = King.new('black')
        table[3][3].cell = black_king
        table[7][7].cell = white_queen
        board.instance_variable_set(:@grid, table)
      end
        it 'returns check' do
          expect(board.in_check?).to eq('check')
        end
    end
    end
end
