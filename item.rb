class Utterance
  attr_accessor :meaning
  attr_accessor :word

  def initialize(meaning, word)
    self.meaning = meaning
    self.word = word
  end

  def to_s
    "'#{word}' (#{meaning})"
  end
end

class Item
  attr_accessor :id
  attr_accessor :age
  attr_accessor :grammar

  InventProbability = 10 # /100
  Alphabet = [ 'a', 'b', 'c', 'd' ]

  def initialize
    self.id = Item.generate_id
    self.age = 0
    self.grammar = Grammar.new
  end

  def speak
    meaning = Meanings.sample
    word = grammar.lookup(meaning)
    if word.nil?
      if should_invent?
        word = utter_randomly
      end
    end
    puts "Item ##{id} speaking '#{word}'"
    Utterance.new(meaning, word) unless word.nil?
  end

  def learn utterance
    unless knows? utterance.meaning
      puts "Item ##{id} learning #{utterance}"
      grammar.learn utterance.meaning, utterance.word
    end
  end

  def knows? meaning
    !grammar.lookup(meaning).nil?
  end

  def should_invent?
    rand(100) < InventProbability
  end

  def utter_randomly
    length = 3 + rand(5)
    (0...length).map{ Alphabet.sample }.join
  end

  def to_s
    "<Item ##{id} age:#{age} grammar.size:#{grammar.size}>"
  end

  def self.generate_id
    @last_id ||= 0
    @last_id+= 1
  end
end


