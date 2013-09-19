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

  def initialize(agent, predicate, patient)
    self.value = {
      Agent:     MeaningAgent.new(agent),
      Patient:   MeaningPatient.new(patient),
      Predicate: MeaningPredicate.new(predicate),
    }
  end

  def agent
    value[:Agent]
  end
  def patient
    value[:Patient]
  end
  def predicate
    value[:Predicate]
  end

  def [](part)
    value[part]
  end

  def type
    :Meaning
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

