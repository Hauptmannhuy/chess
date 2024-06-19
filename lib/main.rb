require_relative 'pieces.rb'
require_relative 'game.rb'
require_relative 'board.rb'
require_relative 'player.rb'
require 'json'

 Game.start

# g = Game.new
# g.play

# g = Game.new
# g.board.place_pieces('black')
# g.board.place_pieces('white')
# # g.board.play_round
# board = g.board.grid
# board[3][0].cell = board[1][0].cell
# board[1][0].cell = nil
# g.board.display
# g.save_promt
# g.load_game
