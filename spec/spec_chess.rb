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
    context 'when pawn already made his first move and user is trying to jump over two squares' do
      it 'returns false' do
        piece = Pawn.new('white')
        piece.change_attribute_of_piece
        table[0][0] = piece
        start = [0,0]
        destination = [2,0]
        expect(piece.valid_move?(start,destination,table)).to eq(false)
      end
    end
  end
  end
  describe '#change_attribute_of_piece' do
    context 'when pawn makes his first move' do
      it 'changes attribute range from 2 to 1' do
        piece = Pawn.new('white')
        expect{piece.change_attribute_of_piece}.to change{piece.instance_variable_get(:@range)}.from(2).to(1)
      end
    end
  end
end

describe Board do
  let(:board){ described_class.new }

  describe '#castling_move_identified?' do
    context 'When start square is white king and destination is white rook' do
      it 'returns true' do
        table =  board.instance_variable_get(:@grid)
        table[0][0].cell = King.new('white')
        table[0][3].cell = Rook.new('white')
        start = [0,0]
        dest = [0,3]
        expect(board.castling_move_identified?(start,dest)).to eq(true)
      end
    end
  end

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
        allow(board).to receive(:select_coordinate).and_return([3,3],[4,3])
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
      allow(board).to receive(:select_coordinate).and_return([3,3],[2,2],[3,3],[4,3])
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
    allow(board).to receive(:select_coordinate).and_return([3,3],[2,3])
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
    allow(board).to receive(:select_coordinate).and_return([3,3],[2,2],[3,3],[4,3])
  end
  it 'changes instance variable @check_declared to false and completes loop' do
    error_message = 'Wrong move!'
    expect(board).to receive(:puts).with(error_message).once
  expect{board.escape_check('white')}.to change{board.instance_variable_get(:@check_declared)}.from(true).to(false)
end
end
context 'when king is in check and player chooses friendly rook and block path to enemy Queen by that exit the check' do
  before do
  table =  board.instance_variable_get(:@grid)
  black_queen = Queen.new('black')
  white_rook = Rook.new('white')
  white_king = King.new('white')
  table[4][0].cell = white_rook
  table[3][3].cell = white_king
  table[7][7].cell = black_queen
  board.instance_variable_set(:@grid, table)
  board.instance_variable_set(:@check_declared, true)
  allow(board).to receive(:puts)
  allow(board).to receive(:select_coordinate).and_return([4,0],[4,4])
  end
   it 'changes instance variable @check_declared to false and completes loop' do
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

  describe "#check_mate" do
    context 'when king in position 1A covered by two enemy rooks on 1H and 2H' do
      it 'returns true' do
        table = board.instance_variable_get(:@grid)
        table[0][0].cell = King.new('white')
        table[1][7].cell = Rook.new('black')
        table[0][7].cell = Rook.new('black')
        expect(board.check_mate('white')).to eq(true)
      end
    end
    context 'when king in position 8H surrounded by enemy rook and knight' do
      it 'returns true' do
        table = board.instance_variable_get(:@grid)
        table[7][7].cell = King.new('white')
        table[6][7].cell = Rook.new('black')
        table[5][5].cell = Knight.new('black')
        expect(board.check_mate('white')).to eq(true)
      end
    end
    context 'Epaulette mate' do
      it 'returns true' do
        table = board.instance_variable_get(:@grid)
        table[7][4].cell = King.new('white')
        table[7][5].cell = Rook.new('white')
        table[7][3].cell = Rook.new('white')
        table[5][4].cell = Queen.new('black')
        expect(board.check_mate('white')).to eq(true)
      end
    end
    context 'Arabian mate' do
      it 'returns true' do
        table = board.instance_variable_get(:@grid)
        table[7][7].cell = King.new('black')
        table[7][6].cell = Rook.new('white')
        table[5][5].cell = Knight.new('white')
        expect(board.check_mate('black')).to eq(true)
      end
    end
    context 'Queen mate' do
      it 'returns true' do
        table = board.instance_variable_get(:@grid)
        table[7][3].cell = King.new('black')
        table[6][3].cell = Queen.new('white')
        table[5][3].cell = King.new('white')
        expect(board.check_mate('black')).to eq(true)
      end
    end
    context 'Rook mate (box mate)' do
      it 'returns true' do
        table = board.instance_variable_get(:@grid)
        table[7][3].cell = King.new('black')
        table[7][0].cell = Rook.new('white')
        table[5][3].cell = King.new('white')
        expect(board.check_mate('black')).to eq(true)
      end
    end
    context 'Smothered mate' do
      it 'returns true' do
        table = board.instance_variable_get(:@grid)
        table[7][7].cell = King.new('black')
        table[7][6].cell = Rook.new('black')
        table[6][6].cell = Pawn.new('black')
        table[6][7].cell = Pawn.new('black')
        table[6][5].cell = Knight.new('white')
        expect(board.check_mate('black')).to eq(true)
      end
    end
    context "Swallow's tail mate (guéridon mate)" do
      it 'returns true' do
        table = board.instance_variable_get(:@grid)
        table[6][4].cell = King.new('black')
        table[7][3].cell = Rook.new('black')
        table[7][5].cell = Rook.new('black')
        table[5][4].cell = Queen.new('white')
        table[5][0].cell = Rook.new('white')
        expect(board.check_mate('black')).to eq(true)
      end
    end
    context 'Triangle mate' do
      it 'returns true' do
        table = board.instance_variable_get(:@grid)
        table[7][3].cell = Rook.new('white')
        table[5][3].cell = Queen.new('white')
        table[6][4].cell = King.new('black')
        table[6][5].cell = Pawn.new('black')
        expect(board.check_mate('black')).to eq(true)
      end
    end
    context "Morphy's mate" do
      it 'returns true' do
        table = board.instance_variable_get(:@grid)
        table[7][7].cell = King.new('black')
        table[6][7].cell = Pawn.new('black')
        table[0][6].cell = Rook.new('white')
        table[5][5].cell = Bishop.new('white')
        expect(board.check_mate('black')).to eq(true)
      end
    end
    context "Lolli's mate" do
      it 'returns true' do
        table = board.instance_variable_get(:@grid)
        table[7][6].cell = King.new('black')
        table[6][6].cell = Queen.new('white')
        table[6][5].cell = Pawn.new('black')
        table[5][5].cell = Pawn.new('white')
        table[5][6].cell = Pawn.new('black')
        expect(board.check_mate('black')).to eq(true)
      end
    end
    context "Max Lange's mate" do
      it 'returns true' do
        table = board.instance_variable_get(:@grid)
        table[7][6].cell = Queen.new('white')
        table[6][6].cell = Pawn.new('black')
        table[6][5].cell = Bishop.new('white')
        table[5][7].cell = Pawn.new('black')
        table[6][7].cell = King.new('black')
        expect(board.check_mate('black')).to eq(true)
      end
    end
    context "Hook mate" do
      it 'returns true' do
        table = board.instance_variable_get(:@grid)
        table[7][4].cell = Rook.new('white')
        table[6][4].cell = King.new('black')
        table[6][5].cell = Pawn.new('black')
        table[5][5].cell = Knight.new('white')
        table[4][4].cell = Pawn.new('white')
        expect(board.check_mate('black')).to eq(true)
      end
    end
    context 'when king in position 4D surrounded by enemy pieces but has escape route' do
      it 'returns false' do
        table = board.instance_variable_get(:@grid)
        table[3][3].cell = King.new('white')
        table[3][2].cell = Rook.new('black')
        table[4][3].cell = Bishop.new('black')
        table[3][4].cell = Knight.new('black')
        expect(board.check_mate('white')).to eq(false)
      end
    end
    context 'when king in position 4D and enemy pawn and Queen attack but king has escape route' do
            it 'returns false' do
              table = board.instance_variable_get(:@grid)
              table[3][3].cell = King.new('white')
              table[4][2].cell = Pawn.new('black')
              table[7][7].cell = Queen.new('black')
              expect(board.check_mate('white')).to eq(false)
           end
    end
  end
  describe '#castling_move' do
    context "when colors of pieces correspond to conditions, didn't make any moves and path not under attack, neither the king" do
      it 'calls #castling_square' do
      table = board.instance_variable_get(:@grid)
      table[0][4].cell = King.new('white')
      table[0][7].cell = Rook.new('white')
      start = [0,4]
      dest = [0,7]
      expect(board).to receive(:castling_square)
      board.castling_move(start,dest)
      end
    end
    context "when colors of pieces don't correspond to conditions, didn't make any moves and path not under attack, neither the king" do
    it 'calls #choose_coordinates' do
    allow(board).to receive(:puts)

    table = board.instance_variable_get(:@grid)
    table[0][4].cell = King.new('black')
    table[0][7].cell = Rook.new('white')
    start = [0,4]
    dest = [0,7]
    expect(board).to receive(:choose_coordinates)
    board.castling_move(start,dest)
    end
  end
  context "when colors of pieces correspond to conditions, but already made moves and path not under attack, neither the king" do
    it 'calls #choose_coordinates' do
    allow(board).to receive(:puts)

    table = board.instance_variable_get(:@grid)
    table[0][4].cell = King.new('white')
    table[0][7].cell = Rook.new('white')
    table[0][7].cell.first_move = false
    start = [0,4]
    dest = [0,7]
    expect(board).to receive(:choose_coordinates)
    board.castling_move(start,dest)
    end
  end
  context "when colors of pieces correspond to conditions, didn't make any moves, but path under attack" do
    it 'calls #choose_coordinates' do
    allow(board).to receive(:puts)
    table = board.instance_variable_get(:@grid)
    table[0][4].cell = King.new('white')
    table[0][7].cell = Rook.new('white')
    table[4][5].cell = Rook.new('black')
    start = [0,4]
    dest = [0,7]
    expect(board).to receive(:choose_coordinates)
    board.castling_move(start,dest)
    end
  end
  context "when king is in check" do
    it 'calls #choose_coordinates' do
    allow(board).to receive(:puts)
    table = board.instance_variable_get(:@grid)
    table[0][4].cell = King.new('white')
    table[0][7].cell = Rook.new('white')
    table[4][4].cell = Rook.new('black')
    start = [0,4]
    dest = [0,7]
    expect(board).to receive(:choose_coordinates)
    board.castling_move(start,dest)
    end
  end
  end
  describe "is_stalemate?" do
    context "Black to move is stalemated. Black is not in check and has no legal move since every square the king might move to is attacked by White." do
      it 'returns true' do
        table = board.instance_variable_get(:@grid)
        board.instance_variable_set(:@move_order, true)
        table[0][0].cell = King.new('white')
        table[7][7].cell = King.new('black')
        table[5][6].cell = Queen.new('white')
        expect(board.is_stalemate?).to be(true)
      end
    end
    context "Black to move is stalemated by pawn in front and king behind the pawn" do
      it 'returns true' do
        table = board.instance_variable_get(:@grid)
        board.instance_variable_set(:@move_order, true)
        table[7][4].cell = King.new('black')
        table[6][4].cell = Queen.new('white')
        table[5][4].cell = King.new('white')
        expect(board.is_stalemate?).to be(true)
      end
    end
    context "Matulović versus Minev stalemate" do
      it 'returns true' do
        table = board.instance_variable_get(:@grid)
        board.instance_variable_set(:@move_order, true)
        table[4][7].cell = King.new('black')
        table[2][7].cell = King.new('white')
        table[3][5].cell = Pawn.new('white')
        table[5][0].cell = Rook.new('white')
        expect(board.is_stalemate?).to be(true)
      end
    end
    context 'Williams versus Harrwitz' do
      it 'returns true' do
        table = board.instance_variable_get(:@grid)
        board.instance_variable_set(:@move_order, false)
        table[0][0].cell = King.new('white')
        table[1][0].cell = Pawn.new('black')
        table[2][1].cell = Rook.new('black')
        table[2][2].cell = Knight.new('black')
        table[3][2].cell = King.new('black')
        expect(board.is_stalemate?).to be(true)
      end
    end
    context "Black to move is stalemated (a deadlock)." do
    it 'returns true' do
      table = board.instance_variable_get(:@grid)
      board.instance_variable_set(:@move_order, true)
      table[0][7].cell = King.new('black')
      table[0][6].cell = Rook.new('black')
      table[0][5].cell = Bishop.new('black')
      table[0][4].cell = King.new('white')
      table[1][4].cell = Pawn.new('black')
      table[1][6].cell = Pawn.new('black')
      table[1][7].cell = Pawn.new('black')
      expect(board.is_stalemate?).to be(true)
    end
  end
  context 'Black to move is stalemated. The bishop has no legal moves because it is pinned to the king by the rook. ' do
    it 'returns true' do
      table = board.instance_variable_get(:@grid)
      board.instance_variable_set(:@move_order, true)
      table[7][0].cell = King.new('black')
      table[7][1].cell = Bishop.new('black')
      table[5][1].cell = King.new('white')
      table[7][7].cell = Rook.new('white')
      expect(board.is_stalemate?).to be(true)

    end
  end
  end
  describe '#el_passant' do
    context 'Black pawn made move as two squares in advance and stopped near the white pawn' do
        it 'takes black pawn and board changes in order el passant movement' do
          table = board.instance_variable_get(:@grid)
          black_pawn = Pawn.new('black')
          black_pawn.en_passant = true
          white_pawn = Pawn.new('white')
          table[3][3].cell = white_pawn
          table[3][4].cell = black_pawn
          board.standard_move([3,3],[3,4])
          expect(table[4][4].cell).to eq(white_pawn)
        end
    end
  end
end
