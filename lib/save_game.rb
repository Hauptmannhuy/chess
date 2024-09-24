module SaveGame

  def load_game
    saves = Dir.children('saves')
    error = 'There is no such save name'
    if saves.empty?
      puts 'The directory is empty'
      return introduction
    end
    puts 'Type the name of the game to load'
    saves.each{|name| puts name}
    input = gets.chomp
    unless saves.include?(input)
      puts error
      input = gets.chomp
    end
    save = deserialize(input)
    @players = JSON.load(save['@players'])
    @board.load_instances(save)
    play
  end

  def save_promt
    puts 'type save if you want to save the game or press enter if not'
    input = gets.chomp
     return false if input != 'save'
      save = to_json
      Dir.mkdir("saves") unless Dir.exist?("saves")
      name = "save #{Dir.children('saves').count}"
      File.new("saves/#{name}",'w')
      f = File.open("saves/#{name}",'w')
      f.write(save)
      f.close
      puts 'Game successfully saved!'
    true
  end

  def deserialize(input)
    f = File.open("saves/#{input}")
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

  module SaveGame::Asd

  end
end
