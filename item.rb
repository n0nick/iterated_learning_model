require_relative 'logger'

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

  Alphabet = [ 'a', 'b', 'c', 'd' ]

  def initialize(probability)
    self.id = Item.generate_id
    self.age = 0
    self.grammar = Grammar.new

    @probability = probability
  end

  def speak
    meaning = Meanings.sample
    word = lookup(meaning)
    if word.empty?
      if should_invent?
        word = utter_randomly
      end
    end
    MyLogger.debug "Item ##{id} speaking '#{word}' (#{meaning})"
    Utterance.new(meaning, word) unless word.nil?
  end

  def lookup(meaning)
    known = []
    unknown = []
    meaning.each do |part, value|
      word = grammar.lookup(value)
      if word
        known << word
      else
        unknown << value
      end
    end

    rest = grammar.lookup(unknown.join('_'))
    if rest
      known << rest
    end

    known.join('')
  end

  def induce utterance
    #1. Incorporation
    MyLogger.debug "Item ##{id} learning #{utterance}"
    grammar.learn utterance.word, utterance.meaning
    #2. Merging
    #utterance.meaning.each do |part, value|
    #  rule = grammar.lookup_partial(part)
    #end
  end

  def knows? meaning
    !grammar.lookup(meaning).nil?
  end

  def should_invent?
    rand(100) < @probability * 100
  end

  def utter_randomly
    length = 3 + rand(5) #TODO magic
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


