require './utils'
require './meanings'

class Grammar < Hash
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

    def single_part?
      partial? && meaning.known_parts.count == 1
    end

    def embed!(part, meaning, index, str)
      self.meaning[part] = :embedded
      self.word = word.sub(index.to_s, str)
    end

    def generalise_part!(part, new_word)
      index = generate_index
      meaning[part] = index
      word.sub! new_word, index.to_s
    end

    def literal
      word.gsub(/[0-9]/, '')
    end

    def to_s
      "#{meaning} -> '#{word}'"
    end

    def clone
      klone = super
      klone.meaning = self.meaning.clone
      klone
    end

    private
    def generate_index
      @_last_index+= 1 % 10
    end
  end

  def learn(meaning, word=nil)
    rule = nil

    if meaning.is_a? Rule
      rule = meaning
    elsif word
      rule = Rule.new(meaning, word)
    end

    add_rule(rule) unless rule.nil?
  end

  def with(part, meaning)
    values.select do |rule|
      rule.meaning[part] == meaning
    end
  end

  def merge(rule)
    rule.meaning.each do |part, meaning|
      if rule.meaning.has?(part)
        new_rule = merge_part(rule.meaning[part], part)
        learn new_rule unless new_rule.nil?
      end
    end
  end

  def merge_part(meaning, part)
    rules = with(part, meaning)
    if rules.count > 1
      words = rules.map { |r| r.word }
      new_word = Utils.longest_common_substr words, /[0-9]/

      unless new_word.empty?
        rules.each do |r|
          delete_rule(r)
          r.generalise_part! part, new_word
          add_rule(r)
        end

        new_meaning = Meaning.new
        new_meaning[part] = meaning
        Rule.new(new_meaning, new_word)
      end
    end
  end

  def clean!
    new_rules = []

    each do |key, rule|
      # split single-part rules
      if rule.single_part?
        new_rules << split_single_rule(rule)
      end

      # remove unrealistic recursive rules "1 -> 1a"
      if rule.partial?
        if rule.meaning.unknown_parts.count == 1
          delete key
        end
      end
    end

    new_rules.each do |rule|
      learn rule
    end
  end

  def lookup(target)
    select do |key, rule|
      target.matches?(rule.meaning)
    end.values
  end

  private

  def add_rule rule
    self[rule.meaning.to_sym] = rule
  end

  def delete_rule rule
    delete rule.meaning.to_sym
  end

  def split_single_rule rule
    part = rule.meaning.known_parts.first
    new_word = rule.literal
    new_meaning = Meaning.new
    new_meaning[part] = rule.meaning[part]
    add_rule Rule.new(new_meaning, new_word)
    rule.generalise_part! part, new_word
    rule
  end
end

