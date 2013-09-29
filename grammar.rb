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

    # generalise part with a new index
    def generalise_part!(part, new_word)
      index = generate_index
      meaning[part] = index
      word.sub! new_word, index.to_s
    end

    # embed new_word in part, replacing index
    def embed!(part, index, new_word)
      self.meaning[part] = :embedded
      self.word = word.sub(index.to_s, new_word)
    end

    # literal (non-digits) part of word
    def literal
      word.gsub(/[0-9]/, '')
    end

    # deep clone
    def clone
      super.tap do |rule|
        rule.meaning = self.meaning.clone
      end
    end

    def to_s
      "#{meaning} -> '#{word}'"
    end

    private
    def generate_index
      @_last_index+= 1
    end
  end

  # learn a new rule
  def learn(meaning, word=nil)
    rule = nil

    if meaning.is_a? Rule
      rule = meaning
    elsif word
      rule = Rule.new(meaning, word)
    end

    add_rule(rule) unless rule.nil?
  end

  # find all rules with same part=meaning
  def with(part, meaning)
    values.select do |rule|
      rule.meaning[part] == meaning
    end
  end

  # merge parts of a given rule
  def merge(rule)
    rule.meaning.each do |part, meaning|
      if rule.meaning.has?(part)
        new_rule = merge_part(rule.meaning[part], part)
        learn(new_rule) unless new_rule.nil?
      end
    end
  end

  def clean!
    new_rules = []

    each do |key, rule|
      # split single-part rules
      if rule.meaning.single_part?
        new_rules << split_single_rule(rule)
      end

      # remove unrealistic recursive rules "1 -> 1a"
      if rule.meaning.known_parts.count == 0
        if rule.meaning.unknown_parts.count <= 1
          delete_rule rule
        end
      end
    end

    new_rules.each do |rule|
      learn rule
    end
  end

  # find all rules matching a meaning
  def lookup(target)
    select do |key, rule|
      target.matches?(rule.meaning)
    end.values
  end

  private

  # add a rule to grammar
  def add_rule rule
    self[rule.meaning.to_sym] = rule
  end

  # remove a rule from grammar
  def delete_rule rule
    delete rule.meaning.to_sym
  end

  # merge all rules with same part=meaning
  def merge_part(meaning, part)
    rules = with(part, meaning)

    if rules.count > 1
      words = rules.map { |r| r.word }
      new_word = Utils.longest_common_substr words, /[0-9]/

      unless new_word.empty?
        # generalise that part in all rules
        rules.each do |r|
          delete_rule(r)
          r.generalise_part! part, new_word
          add_rule(r)
        end

        # create new rule for that part=meaning
        new_meaning = Meaning.new
        new_meaning[part] = meaning
        Rule.new(new_meaning, new_word)
      end
    end
  end

  # split a single-part rule
  #   part=1, other=2, food=Banana -> 1moz2
  # into two rules: one for meaning, one for structure
  #   food=Banana -> 1moz2
  #   part=1, other=2, food=3 -> 132
  def split_single_rule rule
    # rule has a single part
    part = rule.meaning.known_parts.first

    # new rule for the single meaning
    new_word = rule.literal # ('moz')
    new_meaning = Meaning.new # (food=Banana)
    new_meaning[part] = rule.meaning[part]
    new_rule = Rule.new(new_meaning, new_word) # (food=Banana -> moz)
    add_rule(new_rule)

    # generalize the original rule
    #  (part=1, other=2, food=3 -> 132)
    rule.generalise_part! part, new_word
    rule
  end
end

