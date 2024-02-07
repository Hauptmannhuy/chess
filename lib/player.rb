class Player
  attr_reader :name
def self.create_player(input)
  player = Player.new
  @name = input
end
end
