class Game
  def initialize(board = Board.new)
    @board = board
    @players = []
  end

  def start
  puts 'Welcome to chess game!'
  puts 'Human vs Human (press 1)'
  puts 'Human vs computer (press 2)'
  puts 'Please, select game mode to continue.'
    loop do
  input = gets.chomp.to_i
  return two_players_initialize if input.between?(1,2) && input == 1
    puts 'Please, type proper number to choose gamemode.'
    end
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
    