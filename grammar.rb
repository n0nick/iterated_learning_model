class Grammar < Hash
  def learn_meaning(word, meaning)
    self[word.to_sym] = meaning
  end

  def lookup(word)
    self[word.to_sym]
  end
end


