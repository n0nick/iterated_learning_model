class Grammar < Hash
  def learn(meaning, word)
    self[meaning.to_sym] = word
  end

  def lookup(meaning)
    self[meaning.to_sym]
  end
end


