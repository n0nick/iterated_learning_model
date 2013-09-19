class Grammar < Hash
  attr_reader :meanings_count

  def initialize
    @meanings_count = 0
  end

  def learn(word, meaning)
    @meanings_count+= 1 if meaning.full?

    self[word.to_sym] = meaning
  end

  def lookup(word)
    self[word.to_sym]
  end

  def reverse_lookup(target)
    self.select do |word, meaning|
      target.matches?(meaning)
    end
  end
end


