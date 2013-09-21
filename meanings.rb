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
    values[part.to_sym]
  end

  def []=(part, value)
    #TODO DRY
    send("#{part}=", value) if [:agent, :predicate, :patient].include? part
  end

  def each(&block)
    values.each(&block)
  end

  def has?(part)
    values[part].is_a?(Symbol)
  end

  def matches?(other)
    values.keys.inject(true) do |mem, key|
      mem && matches_part?(other, key)
    end
  end

  def full?
    missing_parts.count == 0
  end

  def partial?
    missing_parts.count > 0
  end

  def empty?
    values.keys.inject(true) do |res, part|
      res && !has?(part)
    end
  end

  def missing_parts
    values.keys.inject({}) do |res, part|
      res[values[part]] = part unless has?(part)
      res
    end
  end

  def to_s(include_missing = true)
    values.keys.inject([]) do |res, part|
      value = values[part]
      unless value.nil?
        res << "#{part}=#{value}" if include_missing || has?(part)
      end
      res
    end.join(',')
  end

  def to_sym
    to_s(false).to_sym
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

