class Grammar < Hash
  def initialize
    super
    @by_part = {}
  end

  def learn_meaning(word, meaning)
    meaning.each do |part, value|
      @by_part[part] ||= {}
      @by_part[part][value] ||= []
      @by_part[part][value] << word
    end

    self[word.to_sym] = meaning
  end

  def lookup(word)
    self[word.to_sym]
  end

  def lookup_by_part(part, value)
    @by_part[part][value] || []
  end
end


