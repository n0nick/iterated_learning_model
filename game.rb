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
      unless utterance.nil?
        population.each do |other|
          other.induce utterance
        end
      end
      item.age+= 1
    end

    MyLogger.info "Avg. grammar size: #{average_grammar_size}"
  end

  def spawn_item
    population << Item.new(@options[:probability])
  end

  def kill_random_item
    index = rand(population.size)
    population.delete_at index
  end

  def average_grammar_size
    sizes = grammars.map { |g| g.size }
    sizes.inject(:+).to_f / population.size
  end
end

