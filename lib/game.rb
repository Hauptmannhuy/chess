class Game
  attr_reader :board, :players
  def initialize(board = Board.new)
    @board = board
    @players = []
  end

  def self.start
    game = Game.new
    
    game.introduction
  end

  def introduction
  puts 'Welcome to chess game!'
  puts 'Human vs Human (press 1)'
  puts 'Human vs computer (press 2)'
  puts 'Please, select game mode to continue or type load to load saved game'
    loop do
  input = gets.chomp
  if input.to_i.between?(1,2) && input.to_i == 1
    board.place_pieces('black')
    board.place_pieces('white')
    two_players_initialize
    return play
  elsif input == 'load'
    return load_game
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
      return menu if save_promt
    end
  end

  def menu
    
    
  end

  def load_game
    save = deserialize
    board = save['@board']
    @players = JSON.load(save['@players'])
    @board.load_instances(save)
    play
  end

  def save_promt
    puts 'type save if you want to save the game or press enter if not'
    input = gets.chomp
     return false if input != 'save'
    save = to_json 
    
    File.new('save','w')
    f = File.open('save','w')  
    f.write(save)
    f.close
    true
  end

  def deserialize
    f = File.open('save')
    deser = JSON.load(f)
    deser['@board'] = JSON.load(deser['@board'])
    deser['@board']['@grid'] = JSON.load(deser['@board']['@grid'])
     deser
  end

  def to_json()
    hash = {}
    self.instance_variables.each do |var|
      hash[var] = instance_variable_get(var).to_json
    end
     hash.to_json
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
