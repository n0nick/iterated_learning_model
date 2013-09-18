# encoding: UTF-8

class Meaning
  attr_accessor :agent, :predicate, :patient

  def initialize(agent, predicate, patient)
    self.agent     = agent
    self.predicate = predicate
    self.patient   = patient
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
    "#{agent}_#{predicate}_#{patient}"
  end

  def to_sym
    self.to_s.to_sym
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

