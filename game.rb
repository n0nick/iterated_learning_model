class Game
  attr_accessor :population

  PopulationSize = 10
  Iterations = 500

  def initialize
    init_population
  end

  def play
    Iterations.times do |i|
      puts "Playing turn ##{i}"
      play_turn
      puts
    end

    puts
    puts "Population:"
    puts population
  end

  private

  def init_population
    self.population = []
    PopulationSize.times do
      spawn_item
    end
  end

  def play_turn
    spawn_item
    kill_random_item
    population.each do |item|
      utterance = item.speak
      unless utterance.nil?
        population.each do |other|
          other.learn utterance
        end
      end
      item.age+= 1
    end
  end

  def spawn_item
    population << Item.new
  end

  def kill_random_item
    population.delete_at rand(population.length)
  end
end

