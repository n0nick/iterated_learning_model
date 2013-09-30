require './meanings.rb'

class Utterance
  MinLength = Meaning::Categories.length
  MaxLength = 8

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

