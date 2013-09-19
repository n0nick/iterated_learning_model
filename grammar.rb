require_relative 'utils'

class Grammar
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

  attr_accessor :rules

  def initialize()
    self.rules = {}
  end

  def learn(meaning, word=nil)
    if meaning.is_a? Rule
      rule = meaning
    else
      rule = Rule.new(meaning, word)
    end
    rules[rule.meaning.to_sym] = rule
  end

  def merge(rule)
    new_rules = []

    rule.meaning.each do |part, meaning|
      rules.each do |key, rule2|
        if rule2.meaning[part] == meaning
          new_rules << merge_step(rule, rule2, part)
        end
      end
    end

    new_rules.each do |new_rule|
      learn new_rule
    end
  end

  def merge_step(rule1, rule2, part)
    # create new rule from longest common substring
    new_word = Utils.longest_common_substring(rule1.word, rule2.word)
    new_meaning = Meaning.new
    new_meaning[part] = rule1.meaning[part]

    # update previous rules
    rule1.generalise_part(part, new_word)
    rule2.generalise_part(part, new_word)

    Rule.new(new_meaning, new_word)
  end

  def meanings_count
    rules.select do |key, rule|
      rule.full?
    end.count
  end

  def lookup(target)
    rules.select do |key, rule|
      target.matches?(rule.meaning)
    end.values
  end

  def count
    rules.count
  end

  def to_s
    rules.to_s
  end
end

