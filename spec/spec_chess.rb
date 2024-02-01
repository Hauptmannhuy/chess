require_relative '../lib/board.rb'
require_relative '../lib/pieces.rb'

describe Piece do
  board = Board.new
  table =  board.instance_variable_get(:@grid)
 describe '#valid_move?' do

  describe "pawn movement" do
    context 'when pawn moves one step forward from 2A to 3A' do
      table[1][0].cell = Pawn.new('white')
      piece = table[1][0].cell
      start = [1,0]
      destination = [2,0]
      it 'returns true' do
        expect(piece.valid_move?(start,destination,table)).to eq(true)
      end
    end
    context 'when white pawn takes enemy piece' do
      piece = Pawn.new('white')
      enemy_piece = Pawn.new('black')
      table[6][1].cell = enemy_piece
      table[5][0].cell = piece
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
  let(:board){ described_class.new }

  describe '#in_check?' do


  context 'when king in danger of attack by pawn' do
    before do
      table =  board.instance_variable_get(:@grid)
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
        table =  board.instance_variable_get(:@grid)
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
        table =  board.instance_variable_get(:@grid)
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
        table =  board.instance_variable_get(:@grid)
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
        table =  board.instance_variable_get(:@grid)
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
    context 'when black king is in check and user is trying to escape to correct coordinate' do
      before do
        table =  board.instance_variable_get(:@grid)
        white_queen = Queen.new('white')
        black_king = King.new('black')
        table[3][3].cell = black_king
        table[7][7].cell = white_queen
        board.instance_variable_set(:@grid, table)
        board.instance_variable_set(:@check_declared, true)
        allow(board).to receive(:puts)
        allow(board).to receive(:find_king).and_return([3,3])
        allow(board).to receive(:select_coordinate).and_return([4,3])
      end
      it 'changes instance variable @check_declared to false and completes loop' do
      expect{board.escape_check('black')}.to change{board.instance_variable_get(:@check_declared)}.from(true).to(false)

    end
  end
  context 'when black king is in check and user is trying to escape to correct incorrect coordinate and then to correct coordinate' do
    before do
      table =  board.instance_variable_get(:@grid)
      white_queen = Queen.new('white')
      black_king = King.new('black')
      table[3][3].cell = black_king
      table[7][7].cell = white_queen
      board.instance_variable_set(:@grid, table)
      board.instance_variable_set(:@check_declared, true)
      allow(board).to receive(:puts)
      allow(board).to receive(:find_king).and_return([3,3])
      allow(board).to receive(:select_coordinate).and_return([2,2],[4,3])
    end
    it 'prints error message once and then changes instance variable @check_declared to false and completes loop' do
      error_message = 'Wrong move!'
    expect(board).to receive(:puts).with(error_message).once
    expect{board.escape_check('black')}.to change{board.instance_variable_get(:@check_declared)}.from(true).to(false)

  end
end
context 'when white king is in check and user is trying to escape to correct coordinate' do
  before do
    table =  board.instance_variable_get(:@grid)
    black_queen = Queen.new('black')
    white_king = King.new('white')
    table[3][3].cell = white_king
    table[7][7].cell = black_queen
    board.instance_variable_set(:@grid, table)
    board.instance_variable_set(:@check_declared, true)
    allow(board).to receive(:puts)
    allow(board).to receive(:find_king).and_return([3,3])
    allow(board).to receive(:select_coordinate).and_return([4,3])
  end
  it 'prints error message once and then changes instance variable @check_declared to false and completes loop' do
  expect{board.escape_check('white')}.to change{board.instance_variable_get(:@check_declared)}.from(true).to(false)
end
end
context 'when white king is in check and user is trying to escape to correct incorrect coordinate and then to correct coordinate' do
  before do
    table =  board.instance_variable_get(:@grid)
    black_queen = Queen.new('black')
    white_king = King.new('white')
    table[3][3].cell = white_king
    table[7][7].cell = black_queen
    board.instance_variable_set(:@grid, table)
    board.instance_variable_set(:@check_declared, true)
    allow(board).to receive(:puts)
    allow(board).to receive(:find_king).and_return([3,3])
    allow(board).to receive(:select_coordinate).and_return([2,2],[4,3])
  end
  it 'changes instance variable @check_declared to false and completes loop' do
    error_message = 'Wrong move!'
    expect(board).to receive(:puts).with(error_message).once
  expect{board.escape_check('white')}.to change{board.instance_variable_get(:@check_declared)}.from(true).to(false)
end
end
end

  describe '#king_escape_possible?' do
    context 'when king is in danger of be taken by enemy queen but has escape routes' do
      before do
        table = board.instance_variable_get(:@grid)
        black_queen = Queen.new('black')
        white_king = King.new('white')
        table[3][3].cell = white_king
        table[7][7].cell = black_queen
        board.instance_variable_set(:@grid, table)
        board.instance_variable_set(:@check_declared, true)
      end
      it 'completes iteration and returns true' do
        expect(board.king_escape_possible?('white')).to eq(true)
      end
    end
    context 'when king is in danger of be taken by two enemy rooks and has no escape routes' do
      before do
        table = board.instance_variable_get(:@grid)
        black_rook_1 = Rook.new('black')
        black_rook_2 = Rook.new('black')
        white_king = King.new('white')
        table[0][0].cell = white_king
        table[1][7].cell = black_rook_1
        table[0][7].cell = black_rook_2
        board.instance_variable_set(:@grid, table)
      end
      it 'completes iteration and returns false' do
        expect(board.king_escape_possible?('white')).to eq(false)
      end
    end
  end

  describe '#piece_defend_king_possible?' do
    context 'when king is in danger of taken by enemy rook and friendly piece nearby can cover king by taking enemy piece' do
      it 'ensures that friendly piece can cover king by taking enemy pieces and returns true' do
        table =  board.instance_variable_get(:@grid)
        white_rook = Rook.new('white')
        black_rook_2 = Rook.new('black')
        white_king = King.new('white')
        table[0][0].cell = white_king
        table[7][7].cell = white_rook
        table[0][7].cell = black_rook_2
        expect(board.piece_defend_king_possible?('white')).to eq(true)
      end
    end
    context 'when king is in danger of taken by enemy pieces and friendly piece can block path of enemy piece' do
      it 'ensures that friendly piece can save king by blocking path of enemy piece and returns true' do
        table =  board.instance_variable_get(:@grid)
        table[0][0].cell = King.new('white')
        table[7][0].cell = Queen.new('black')
        table[7][4].cell = Bishop.new('white')
        expect(board.piece_defend_king_possible?('white')).to eq(true)
      end
    end
    context 'when king is in danger of taken by enemy pieces and friendly piece cannot save the king' do
        it 'ensures that friendly piece cannot cover king and returns false' do
          table = board.instance_variable_get(:@grid)
          white_rook = Rook.new('white')
          black_rook_2 = Rook.new('black')
          black_rook_1 = Rook.new('black')
          white_king = King.new('white')
          table[7][0].cell = black_rook_1
          table[0][7].cell = black_rook_2
          table[0][0].cell = white_king
          table[7][7].cell = white_rook
          expect(board.piece_defend_king_possible?('white')).to eq(false)
        end
      end
  end


end
