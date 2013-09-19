require_relative 'utils'

class Grammar < Hash
  class Rule
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

  def learn(meaning, word=nil)
    if meaning.is_a? Rule
      rule = meaning
    else
      rule = Rule.new(meaning, word)
    end
    self[rule.meaning.to_sym] = rule
  end
  end

  def meanings_count
    self.select do |key, rule|
      rule.full?
    end.count
  end

  def lookup(target)
    self.select do |key, rule|
      target.matches?(rule.meaning)
    end.values
  end
end

