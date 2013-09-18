# encoding: UTF-8

class MeaningBase
  attr_accessor :value

  def initialize(value)
    self.value = value
  end

  def to_sym
    self.to_s.to_sym
  end
end

class MeaningAgent < MeaningBase
  def to_s
    "Agent=#{value}"
  end
end

class MeaningPredicate < MeaningBase
  def to_s
    "Predicate=#{value}"
  end
end

class MeaningPatient < MeaningBase
  def to_s
    "Patient=#{value}"
  end
end

class Meaning < MeaningBase
  include Enumerable

  def initialize(agent, predicate, patient)
    self.value = {
      agent:     MeaningAgent.new(agent),
      patient:   MeaningPatient.new(patient),
      predicate: MeaningPredicate.new(predicate),
    }
  end

  def agent
    value[:agent]
  end
  def patient
    value[:patient]
  end
  def predicate
    value[:predicate]
  end

  def each(&block)
    value.each(&block)
  end

  def to_s
    "S/#{agent},#{patient},#{predicate}"
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

