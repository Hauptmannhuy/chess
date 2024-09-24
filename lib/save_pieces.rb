module SavePieces
  def to_json(_options = {})
  hash = {}
  instance_variables.each do |var|
    hash[var] = if var == :@symbol
                  self.class.to_s.downcase
                else
                  instance_variable_get(var)
                end
  end
  hash
  end
end
