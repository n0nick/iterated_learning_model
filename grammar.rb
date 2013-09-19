class Grammar < Hash
  def learn(word, meaning)
    self[word.to_sym] = meaning
  end

  def lookup(word)
    self[word.to_sym]
  end

  def reverse_lookup(target)
    self.select do |word, meaning|
      meaning.matches?(target)
    end
  end
end


