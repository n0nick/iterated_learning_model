require './logger'
require './grammar'
require './meanings'
require './utterance'

class Player
  attr_accessor :id
  attr_accessor :age
  attr_accessor :grammar

  Alphabet = [ 'a', 'b', 'c', 'd' ]

  def initialize(probability)
    self.id = Player.generate_id
    self.grammar = Grammar.new
    self.age = 0

    @probability = probability
  end

  # (try to) articulate a given meaning
  def speak meaning
    MyLogger.debug "Player ##{id} speaking #{meaning}"
    word = lookup(meaning, should_invent?)
    Utterance.new(meaning, word) unless word.nil?
  end

  # learn from a neighbour's utterance
  def learn utterance
    MyLogger.debug "Player ##{id} learning #{utterance}"
    # 1. Incorporation
    rule = grammar.learn utterance.meaning, utterance.word
    # 2. Merging
    grammar.merge rule if rule
    # 3. Cleaning
    grammar.clean!
  end

  # count possible meanings available
  def meaning_count
    Meanings.inject(0) do |count, m|
      count+= 1 if can_speak?(m)
      count
    end
  end

  def to_s
    "<Player ##{id} age:#{age} " +
    "grammar.size:#{grammar.count}>"
  end

  def self.generate_id
    @_last_id ||= 0
    @_last_id+= 1
  end

  # utter a random word
  def utter_randomly
    length = Utterance::MinLength +
      rand(Utterance::MaxLength - Utterance::MinLength)
    (0...length).map{ Alphabet.sample }.join
  end

  private

  # whether to invent a new word
  def should_invent?
    rand(100) < @probability * 100
  end

  # is meaning possible thru grammar
  def can_speak?(meaning)
    !lookup(meaning, false).nil?
  end

  # return word representing meaning, if available
  def lookup(meaning, should_invent=false)
    word = nil
    unless meaning.empty?
      rules = grammar.lookup(meaning)
      if rules.empty?
        if should_invent
          word = utter_randomly
          self.learn Utterance.new meaning, word
        end
      else
        rules.sort_by! do |rule|
          rule.meaning.missing_parts.count
        end.reverse!
        rules.each do |rule|
          if rule.meaning.full?
            word = rule.word
            break
          else
            current = rule.clone
            current.meaning.missing_parts.each do |index, part|
              required = Meaning.new
              required[part] = meaning[part]
              res = lookup(required, should_invent)
              if res.nil?
                word = nil
                break
              else
                current.embed!(part, index, res)
              end
            end
            if current.meaning.full?
              word = current.word
              break
            end
          end
        end
      end
    end
    word
  end
end

