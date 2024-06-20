require_relative 'pieces.rb'
require_relative 'game.rb'
require_relative 'board.rb'
require_relative 'player.rb'
require 'json'

#  Game.start
g = Game.new 
g.load_game
# f = g.deserialize
# g.board.load_instances(f)
# g.board.load_piece('king','white',true)

# g.play

# g = Game.new
# g.board.place_pieces('black')
# g.board.place_pieces('white')
# g.board.en_passant_queue = [g.board.grid[0][0].cell]
# g.board.find_en_passant_positions 
# # g.board.play_round
# board = g.board.grid
# board[3][0].cell = board[1][0].cell
# board[1][0].cell = nil
# g.board.display
# g.save_promt
# g.load_game
