class Grammar < Hash
  class Item
    attr_accessor :meaning, :word

    def initialize(meaning, word)
      self.meaning = meaning
      self.word = word
    end

    def full?
      meaning.full?
    end

    def partial?
      meaning.partial?
    end

    def to_s
      "'#{word}'"
    end
  end

  def learn(meaning, word)
    self[meaning.to_sym] = Item.new(meaning, word)
  end

  def meanings_count
    self.select do |key, item|
      item.full?
    end.count
  end

  def lookup(target)
    self.select do |key, item|
      target.matches?(item.meaning)
    end.values
  end
end

