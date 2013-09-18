#!/usr/bin/env ruby

require_relative 'game'
require_relative 'item'
require_relative 'grammar'
require_relative 'meanings'

require 'optparse'
options = {
  population: 10,
  iterations: 500
}
OptionParser.new do |opts|
  opts.banner = "Usage: learner.rb [options]"

  opts.on("-p N", "--population N", Integer,
          "Set population size") do |v|
    options[:population] = v
  end

  opts.on("-i N", "--iterations N", Integer,
          "Set iterations count") do |v|
    options[:iterations] = v
  end
end.parse!

game = Game.new(options[:population])
game.play(options[:iterations])
