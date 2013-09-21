require_relative 'logger'
require_relative 'grammar'
require_relative 'meanings'
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
    # 1. Incorporation
    rule = grammar.learn utterance.meaning, utterance.word
    # 2. Merging
    grammar.merge rule if rule
    # 3. Cleaning
    grammar.clean
  end

  def to_s
    "<Player ##{id} age:#{age} " +
    "grammar.size:#{grammar.count} " +
    "grammar.meanings:#{grammar.meanings_count}>"
  end

  def self.generate_id
    @_last_id ||= 0
    @_last_id+= 1
  end

  private

  def should_invent?
    rand(100) < @probability * 100
  end

  def lookup(meaning, should_invent)
    MyLogger.debug "Lookup: #{meaning}"
    word = nil
    unless meaning.empty?
      rules = grammar.lookup(meaning)
      if rules.empty?
        if should_invent
          word = utter_randomly
        end
      else
        rules.sort_by! do |rule|
          rule.meaning.missing_parts.count
        end.reverse!
        rules.each do |rule|
          if rule.full?
            return rule.word
          else
            current = rule.clone
            current.meaning.missing_parts.each do |index, part|
              required = Meaning.new #TODO
              required[part] = meaning[part]
              res = lookup(required, should_invent)
              if res.nil?
                return nil
              else
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
    MyLogger.debug "Lookup result: #{word.inspect}"
    word
  end

  def utter_randomly
    length = 3 + rand(5) #TODO magic
    (0...length).map{ Alphabet.sample }.join
  end
end

