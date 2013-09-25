require './logger'
require './player'

class Game
  attr_accessor :population

  def initialize(options)
    @options = options

    @generation = 0

    init_population(@options[:population])
  end

  def play(generations=nil, iterations = nil)
    generations ||= @options[:generations]

    generations.times do
      @generation+= 1
      play_step(iterations)
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

  def noise?
    rand(1000) < 0.001 * 1000 #TODO
  end

  def play_step(iterations = nil)
    iterations ||= @options[:iterations]

    # Replace a random player
    index = random_player_index
    population[index] = Player.new(@options[:probability])
    hearer = population[index]

    iterations.times do |i|
      meaning = Meanings.sample

      speaker   = population[random_neighbor_index(index)]
      if noise?
        word = speaker.utter_randomly
        utterance = Utterance.new(meaning, word)
      else
        utterance = speaker.speak(meaning)
      end

      if utterance # something was said
        hearer.learn(utterance)
      end

      log_info(i) if @options[:print_after] == :iteration
    end

    log_info if @options[:print_after] == :generation

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

  def log_info(iteration = nil)
    info = []
    info << "g#%4d" % @generation
    (info << "i#%3d" % iteration) if iteration
    if @options[:print_grammar_size]
      info << "grammar: %5.1f" % average_grammar_size
    end
    if @options[:print_meaning_count]
      info << "meanings: %5.1f" % average_meaning_count
    end
    MyLogger.info info.join("\t")
  end
end

