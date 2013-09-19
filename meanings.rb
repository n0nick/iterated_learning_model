# encoding: UTF-8

class MeaningBase
  attr_accessor :value

  def initialize(value)
    self.value = value
  end

  def to_s
    "#{type}=#{value}"
  end

  def to_sym
    self.to_s.to_sym
  end

  def ==(other)
    self.to_s == other.to_s
  end
end

class MeaningAgent < MeaningBase
  def type
    :Agent
  end
end

class MeaningPredicate < MeaningBase
  def type
    :Predicate
  end
end

class MeaningPatient < MeaningBase
  def type
    :Patient
  end
end

class Meaning < MeaningBase
  include Enumerable

  attr_accessor :agent, :predicate, :patient

  def initialize(agent = nil, predicate = nil, patient = nil)
    agent     = MeaningAgent.new(agent)         if agent.is_a?(Symbol)
    predicate = MeaningPredicate.new(predicate) if predicate.is_a?(Symbol)
    patient   = MeaningPatient.new(patient)     if patient.is_a?(Symbol)

    self.agent = agent
    self.predicate = predicate
    self.patient = patient
  end

  def type
    :Meaning
  end

  def value
    {
      agent:     agent,
      predicate: predicate,
      patient:   patient,
    }
  end

  def [](part)
    value[part.to_s.downcase.to_sym]
  end

  def each(&block)
    value.each(&block)
  end

  def matches?(other)
    value.keys.inject(true) do |mem, key|
      mem && matches_part?(other, key)
    end
  end

  def full?
    value.values.inject(true) do |mem, val|
      mem && !val.nil?
    end
  end

  def partial?
    !full?
  end

  def to_s
    "S/#{agent},#{patient},#{predicate}"
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

