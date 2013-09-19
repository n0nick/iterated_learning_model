class Utterance
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

