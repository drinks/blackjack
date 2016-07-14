# Encoding: utf-8
# frozen_string_literal: true
require_relative '../blackjack'

namespace :blackjack do
  task :play do
    game = Blackjack::Game.new
    game.play!
  end
end

desc 'Play a hand of blackjack'
task :blackjack do
  Rake::Task['blackjack:play'].invoke
end
