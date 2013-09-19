require_relative 'logger'
require_relative 'player'

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
    population.map do |player|
      player.grammar
    end
  end

  private

  def init_population(size)
    self.population = []
    size.times do
      spawn_player
    end
  end

  def play_turn
    spawn_player
    kill_random_player
    population.each do |player|
      utterance = player.speak Meanings.sample
      if utterance # something was said
        population.each do |other|
          other.learn utterance
        end
      end
      player.age+= 1
    end

    avg_grammar  = average_grammar_attribute(:count)
    avg_meanings = average_grammar_attribute(:meanings_count)
    MyLogger.info "grammar: #{avg_grammar} meanings: #{avg_meanings}"
  end

  def spawn_player
    population << Player.new(@options[:probability])
  end

  def kill_random_player
    index = rand(population.size)
    population.delete_at index
  end

  def average_grammar_attribute(att)
    sizes = grammars.map { |g| g.send(att) }
    sizes.inject(:+).to_f / population.size
  end
end

