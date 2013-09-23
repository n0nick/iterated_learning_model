require_relative 'logger'
require_relative 'player'

class Game
  attr_accessor :population

  def initialize(options)
    @options = options

    init_population(@options[:population])
  end

  def play(iterations=nil, sub_iterations = nil)
    iterations ||= @options[:iterations]

    iterations.times do |i|
      play_turn(sub_iterations)

      MyLogger.info "#%4d grammar: %5.1f meanings: %5.1f" %
        [i, average_grammar_size, average_meaning_count]
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

  def play_turn(sub_iterations = nil)
    sub_iterations ||= @options[:sub_iterations]

    # Replace a random player
    index = random_player_index
    population[index] = Player.new(@options[:probability])

    sub_iterations.times do
      speaker   = population[random_neighbor_index(index)]
      utterance = speaker.speak(Meanings.sample)
      if utterance # something was said
        population[index].learn(utterance)
      end
    end

    population.each do |player|
      player.age+= 1
    end
  end

  def random_player_index
    rand(population.size)
  end

  def random_neighbor_index(index)
    direction = [+1, -1].sample
    (index + direction) % population.size
  end

  def spawn_player
    population << Player.new(@options[:probability])
  end

  def average_grammar_size
    sizes = grammars.map(&:size)
    sizes.inject(:+).to_f / population.size
  end

  def average_meaning_count
    sizes = population.map(&:meaning_count)
    sizes.inject(:+).to_f / population.size
  end
end

