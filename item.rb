require_relative 'logger'
require_relative 'utterance'

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

  def speak(meaning)
    MyLogger.debug "Item ##{id} speaking #{meaning}"
  end

  def learn utterance
    MyLogger.debug "Item ##{id} learning #{utterance}"
  end

  def should_invent?
    rand(100) < @probability * 100
  end

  def to_s
    "<Item ##{id} age:#{age} grammar.size:#{grammar.size}>"
  end

  def self.generate_id
    @last_id ||= 0
    @last_id+= 1
  end
end


