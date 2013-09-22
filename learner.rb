#!/usr/bin/env ruby

require_relative 'logger'
require_relative 'game'
require_relative 'grammar'
require_relative 'meanings'

require 'optparse'
options = {
  population: 10,
  iterations: 500,
  probability: 2,
  print_grammars: false,
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

  opts.on("--probability N", Float,
         "Set invention probability") do |p|
    options[:probability] = p
  end

  opts.on("-d", "--debug",
           "Show debug messages") do |debug|
    if debug
      require 'pry'
      options[:debug] = true
      MyLogger.level = Logger::DEBUG
    end
  end

  opts.on("--print-grammars",
         "Print final grammars") do |print_grammars|
    options[:print_grammars] = true
  end
end.parse!

game = Game.new(options)
game.play(options[:iterations])

if options[:print_grammars]
  puts game.grammars
end

if options[:debug]
  binding.pry
end
