require_relative 'pieces.rb'
require_relative 'game.rb'
require_relative 'board.rb'
require_relative 'player.rb'

# board = Board.new
# board.clean_board
# board.grid[3][3].cell = King.new('black')
# board.grid[0][7].cell = Rook.new('black')
# board.grid[7][0].cell = Rook.new('black')
# board.grid[0][0].cell = King.new('white')
# board.grid[7][7].cell = Rook.new('white')

# puts board.piece_defend_king_possible?('white')
# board.escape_check('white')
# loop do

#   board.display
#   board.player_move
#   board.display
# end


# board.player_move

# board.grid[][3].cell.range = 1
# board.in_check?

Game.start
