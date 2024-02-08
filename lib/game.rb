class Game
  attr_reader :board, :players
  def initialize(board = Board.new)
    @board = board
    @players = []
  end

  def self.start
    game = Game.new
    game.board.place_pieces('black')
    game.board.place_pieces('white')
    game.introduction
  end

  def introduction
  puts 'Welcome to chess game!'
  puts 'Human vs Human (press 1)'
  puts 'Human vs computer (press 2)'
  puts 'Please, select game mode to continue.'
    loop do
  input = gets.chomp.to_i
  if input.between?(1,2) && input == 1
    two_players_initialize
    return play
  else
    puts 'Please, type proper number to choose gamemode.'
  end
    end
  end

  def play
    loop do
      announcment
      display_board
      play_round
      display_board
      in_check?
      return declare_game_over if check_mate? || stalemate?
      end_turn
    end
  end

  def check_mate?
   board.check_mate

  end

  def stalemate?
   board.is_stalemate?
  end

  def declare_game_over
    check_declared = board.check_declared
    move_order = board.move_order
    if check_declared == true
      puts "#{players[0]} wins!" if move_order == false
      puts "#{players[1]} wins!" if move_order == true
    else
      puts "It's a draw!"
    end
  end

  def end_turn
    en_passant_dequeue
    switch_turn
  end

  def en_passant_dequeue
    move_order = self.board.move_order
    piece = self.board.en_passant_queue.last
    queue = self.board.en_passant_queue
    if move_order == false && !queue.empty?
        self.board.en_passant_dequeue if piece.color == 'black'
    elsif move_order == true && !queue.empty?
      self.board.en_passant_dequeue if piece.color == 'white'
    end
    puts queue
  end

  def in_check?
    self.board.in_check?
  end

  def display_board
    self.board.display
  end

  def announcment
    move_order = @board.move_order
    if move_order == false
    puts  "White's turn!"
    else
    puts  "Black's turn!"
    end
  end

  def play_round
    self.board.play_round
  end

  def switch_turn
    self.board.move_turn_order
  end

  def two_players_initialize
    taken_names = []
   until taken_names.length == 2
    puts "Player #{taken_names.empty? ? '1' : '2'}, enter your name"
     input = gets.chomp
     verified_input = verify_name(input, taken_names)
     if verified_input
       taken_names << verified_input
       create_player(verified_input)
     else
       puts 'You cannot enter name that already exists!'
     end
   end
  end

  def create_player(input)
    @players << Player.create_player(input)
  end

  def verify_name(input,taken_names)
    return input if !taken_names.include?(input)
  end


end
