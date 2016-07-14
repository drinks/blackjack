#!/usr/bin/env rake
# Encoding: utf-8
# frozen_string_literal: true
require './lib/blackjack'

Dir.glob('lib/tasks/*.rake').each { |r| import r }

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

  desc 'Run the test suite'
  task default: [:spec]
rescue LoadError
  puts 'RSpec is not installed! Please run `bundle` before using this command.'
end
