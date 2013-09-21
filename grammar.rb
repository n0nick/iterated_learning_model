require_relative 'utils'
require_relative 'meanings'

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

    def embed!(part, meaning, index, str)
      self.meaning[part] = :embedded
      self.word = word.sub(index.to_s, str)
    end

    def generalise_part!(part, new_word)
      index = generate_index
      meaning[part] = index
      word.sub! new_word, index.to_s
    end

    def remove_part!(part)
      word.sub! meaning[part].to_s, ''
      meaning[part] = nil
      word
    end

    def clean!
      if meaning.partial?
        if meaning.known_parts.count == 1
          meaning.missing_parts.each do |index, part|
            remove_part!(part)
          end
        end
      end
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
    new_rules = []

    rule.meaning.each do |part, meaning|
      if rule.meaning.has?(part)
        new_rule = merge_part(rule, part)
        new_rules << new_rule unless new_rule.nil?
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
    each do |key, rule|
      rule.clean!

      # remove unrealistic recursive rules "1 -> 1a"
      if rule.partial?
        if rule.meaning.unknown_parts.count == 1
          delete key
        end
      end
    end
  end

  def meanings_count
    #TODO this is wrong
    select do |key, rule|
      rule.full?
    end.count
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
end

