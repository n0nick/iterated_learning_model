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
  attr_accessor :agent, :predicate, :patient

  def initialize(agent, predicate, patient)
    self.agent     = MeaningAgent.new(agent)
    self.predicate = MeaningPredicate.new(predicate)
    self.patient   = MeaningPatient.new(patient)
  end

  def get_part(part)
    case part
    when :agent
      agent
    when :predicate
      predicate
    when :patient
      patient
    else
      nil
    end
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

