#!/usr/bin/env ruby

require_relative 'logger'
require_relative 'game'
require_relative 'grammar'
require_relative 'meanings'

require 'pry'

MyLogger.level = Logger::DEBUG

m1 = Meaning.new(:Jack, :likes, :Dan)
m2 = Meaning.new(:Jack, :likes, :Ben)
m3 = Meaning.new(:Jack, :hates, :Moe)
m4 = Meaning.new(:Jack, :likes, :Moe)

p = Player.new 1
g = p.grammar

g.learn m1, 'abcd'
g.learn m2, 'abce'
g.learn m3, 'afgh'
g.learn m4, 'abch'

rules = g.values
r1 = rules[0]
r2 = rules[1]
r3 = rules[2]
r4 = rules[3]

g.merge r1
g.merge r2
g.merge r3
g.merge r4

g.clean #TODO integrate somewhere?

m5 = Meaning.new(:Jack, :hates, :Dan)
w = p.speak m5 # 'afgd'
puts w.inspect

m5 = Meaning.new(:Jack, :hates, :Ben)
w = p.speak m5 # 'afge'
puts w.inspect

binding.pry
