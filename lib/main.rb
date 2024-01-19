require_relative 'pieces.rb'
require_relative 'game.rb'
require_relative 'board.rb'
require_relative 'player.rb'


board = Board.new

board.display
board.player_move
board.display
