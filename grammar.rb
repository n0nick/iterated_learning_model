class Grammar < Hash
  class Item
    attr_accessor :meaning, :word

    def initialize(meaning, word)
      self.meaning = meaning
      self.word = word

      @_last_index = 0
    end

    def full?
      meaning.full?
    end

    def partial?
      meaning.partial?
    end

    def embed!(index, str)
      self.word = word.gsub(index, str)
    end

    def generalise_part(part, word)
      index = generate_index
      meaning[part] = index
      self.word.sub! word, index.to_s
    end

    def to_s
      "'#{word}'"
    end

    private
    def generate_index
      @_last_index+= 1
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

