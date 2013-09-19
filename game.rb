require_relative 'logger'

class Game
  attr_accessor :population

  def initialize(options)
    @options = options

    init_population(@options[:population])
  end

  def play(iterations)
    iterations.times do |i|
      MyLogger.debug "Playing turn ##{i}"
      play_turn
    end

    MyLogger.debug "Population: #{population}"
  end

  def grammars
    population.map do |item|
      item.grammar
    end
  end

  private

  def init_population(size)
    self.population = []
    size.times do
      spawn_item
    end
  end

  def play_turn
    spawn_item
    kill_random_item
    population.each do |item|
      utterance = item.speak Meanings.sample
      if utterance # something was said
        population.each do |other|
          other.learn utterance
        end
      end
      item.age+= 1
    end

    MyLogger.info "grammar: #{average_grammar_attribute(:count)}"
    MyLogger.info "meanings: #{average_grammar_attribute(:meanings_count)}"
  end

  def spawn_item
    population << Item.new(@options[:probability])
  end

  def kill_random_item
    index = rand(population.size)
    population.delete_at index
  end

  def average_grammar_attribute(att)
    sizes = grammars.map { |g| g.send(att) }
    sizes.inject(:+).to_f / population.size
  end
end

