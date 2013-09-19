# encoding: UTF-8

class Meaning
  attr_accessor :agent, :predicate, :patient

  def initialize(agent = nil, predicate = nil, patient = nil)
    self.agent     = agent
    self.predicate = predicate
    self.patient   = patient
  end

  def values
    {
      agent: agent,
      predicate: predicate,
      patient: patient,
    }
  end

  def [](part)
    values[part.to_s.downcase.to_sym]
  end

  def each(&block)
    values.each(&block)
  end

  def matches?(other)
    values.keys.inject(true) do |mem, key|
      mem && matches_part?(other, key)
    end
  end

  def full?
    values.values.inject(true) do |mem, val|
      mem && !val.nil?
    end
  end

  def partial?
    not full?
  end

  def to_s
    "S/Agent=#{agent},Patient=#{patient},Predicate=#{predicate}"
  end

  def to_sym
    to_s.to_sym
  end

  private
  def matches_part?(other, part)
    other[part].nil? || other[part] == self[part]
  end
end

MeaningObjects = [
  :Mike, :John, :Mary, :'Tu ̈nde', :Zoltan
]

MeaningActions = [
  :Loves, :Knows, :Hates, :Likes, :Finds
]

Meanings = []

MeaningObjects.each do |agent|
  MeaningActions.each do |predicate|
    (MeaningObjects - [agent]).each do |patient|
      Meanings << Meaning.new(agent, predicate, patient)
    end
  end
end

