class Game
  attr_accessor :population

  def initialize(population_size)
    init_population(population_size)
  end

  def play(iterations)
    iterations.times do |i|
      puts "Playing turn ##{i}"
      play_turn
      puts
    end

    puts "Population:"
    puts population
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
    index = rand(population.length)
    population.delete_at index
  end
end

