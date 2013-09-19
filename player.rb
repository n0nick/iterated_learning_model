require_relative 'logger'
require_relative 'utterance'

class Player
  attr_accessor :id
  attr_accessor :age
  attr_accessor :grammar

  Alphabet = [ 'a', 'b', 'c', 'd' ]

  def initialize(probability)
    self.id = Player.generate_id
    self.age = 0
    self.grammar = Grammar.new

    @probability = probability
  end

  def speak(meaning)
    MyLogger.debug "Player ##{id} speaking #{meaning}"
    word = lookup(meaning, should_invent?)
    Utterance.new meaning, word
  end

  def learn utterance
    MyLogger.debug "Player ##{id} learning #{utterance}"
    grammar.learn utterance.meaning, utterance.word
  end

  def to_s
    "<Player ##{id} age:#{age} grammar.size:#{grammar.size}>"
  end

  def self.generate_id
    @last_id ||= 0
    @last_id+= 1
  end

  private

  def should_invent?
    rand(100) < @probability * 100
  end

  def lookup(meaning, should_invent)
    items = grammar.lookup(meaning)
    if items.empty?
      if should_invent
        utter_randomly
      end
    else
      items.sort_by! do |item|
        item.meaning.missing_parts.count
      end
      items.each do |item|
        if item.full?
          return item.word
        else
          current = item.clone
          current.missing_parts.each do |index, part|
            res = self.lookup(meaning[part], should_invent)
            unless res.nil?
              current.embed!(index, res)
            end
          end
          if current.full?
            return current.word
          end
        end
      end
    end
  end

  def utter_randomly
    length = 3 + rand(5) #TODO magic
    (0...length).map{ Alphabet.sample }.join
  end
end

