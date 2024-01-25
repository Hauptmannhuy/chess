require_relative 'pieces.rb'
require_relative 'game.rb'
require_relative 'board.rb'
require_relative 'player.rb'

game = Game.new
game.play
# board = Board.new
# board.grid.each_with_index do |row,x|
#   row.each_with_index do |square,y|
#     square.cell = nil
#   end
# end
# board.grid[3][3].cell = King.new('white')
# board.grid[7][7].cell = Queen.new('black')

# board.escape_check('white')
# loop do

#   board.display
#   board.player_move
#   board.display
# end


# board.player_move

# board.grid[][3].cell.range = 1
# board.in_check?
