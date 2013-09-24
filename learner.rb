#!/usr/bin/env ruby

require './logger'
require './game'
require './grammar'
require './meanings'

require 'optparse'
options = {
  :population => 10,
  :iterations => 5000,
  :sub_iterations => 100,
  :probability => 2,
  :print_grammars => false,
  :print_grammar_size => true,
  :print_meaning_count => false,
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

  opts.on("-si N", "--sub-iterations N", Integer,
         "Set sub-iterations count") do |v|
    options[:sub_iterations] = v
  end

  opts.on("--probability N", Float,
         "Set invention probability") do |p|
    options[:probability] = p
  end

  opts.on("-d", "--debug",
           "Show debug messages") do |debug|
    require 'pry'
    options[:debug] = true
    MyLogger.level = Logger::DEBUG
  end

  opts.on("--[no-]print-grammar-size",
          "Print grammar sizes after each turn") do |v|
    options[:print_grammar_size] = v
  end

  opts.on("--[no-]print-meaning-count",
          "Print meaning counts after each turn") do |v|
    options[:print_meaning_count] = v
  end

  opts.on("--print-grammars",
         "Print final grammars") do |print_grammars|
    options[:print_grammars] = true
  end
end.parse!

game = Game.new(options)
game.play

if options[:print_grammars]
  puts game.grammars
end

if options[:debug]
  binding.pry
end
