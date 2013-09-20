require_relative 'utils'
require_relative 'meanings'

class Grammar
  class Rule
    attr_accessor :meaning, :word

    def initialize(meaning, word)
      self.meaning = meaning.clone
      self.word    = word.clone

      @_last_index = 0
    end

    def full?
      meaning.full?
    end

    def partial?
      meaning.partial?
    end

    def embed!(index, str)
      self.word = word.sub(index, str)
    end

    def generalise_part!(part, word)
      index = generate_index
      self.meaning[part] = index
      self.word.sub! word, index.to_s
    end

    def clean
    end

    def to_s
      "#{meaning} -> '#{word}'"
    end

    private
    def generate_index
      @_last_index+= 1 % 10
    end
  end

  attr_accessor :rules

  def initialize()
    self.rules = {}
  end

  def learn(meaning, word=nil)
    rule = nil

    if meaning.is_a? Rule
      rule = meaning
    elsif word
      rule = Rule.new(meaning, word)
    end

    unless rule.nil?
      rules[rule.meaning.to_sym] = rule
    end
  end

  def with(part, meaning)
    rules.values.select do |rule|
      rule.meaning[part] == meaning
    end
  end

  def merge(rule)
    new_rules = []

    rule.meaning.each do |part, meaning|
      if rule.meaning.has?(part)
        new_rule = merge_part(rule, part)
        new_rules << new_rule
      end
    end

    new_rules.each do |new_rule|
      learn new_rule
    end
  end

  def merge_part(rule, part)
    meaning = rule.meaning[part]

    rules = with(part, meaning)
    if rules.count > 1
      words = rules.map { |r| r.word }
      new_word = Utils.longest_common_substr words, /[0-9]/

      unless new_word.empty?
        rules.each do |r|
          r.generalise_part! part, new_word
        end

        new_meaning = Meaning.new
        new_meaning[part] = meaning
        Rule.new(new_meaning, new_word)
      end
    end
  end

  def clean
    rules.each do |key, rule|
      rule.clean
    end
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
    '{' + rules.values.inject([]) do |mem, rule|
      mem << rule.to_s
    end.join('; ') + '}'
  end
end

