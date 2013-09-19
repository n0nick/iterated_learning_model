class Grammar < Hash
  def initialize
    super
    @reverse = Hash.new
  end

  def learn(word, meaning)
    @reverse[meaning.to_sym] ||= []
    @reverse[meaning.to_sym] << word
    self[word.to_sym] = meaning
  end

  def lookup(word)
    self[word.to_sym]
  end

  def reverse_lookup(meaning)
    @reverse[meaning.to_sym]
  end
end


