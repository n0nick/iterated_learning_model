class Grammar < Hash
  def initialize
    super
  end

  def learn(word, meaning)
    self[word.to_sym] = meaning
  end

  def lookup(word)
    self[word.to_sym]
  end
end


