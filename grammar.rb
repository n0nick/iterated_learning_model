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

  attr_reader :meanings_count

  def initialize
    @meanings_count = 0
  end

  def learn(meaning, word)
    @meanings_count+= 1 if meaning.full?

    self[meaning.to_sym] = Item.new(meaning, word)
  end

  def lookup(target)
    self.select do |key, item|
      target.matches?(item.meaning)
    end
  end
end

