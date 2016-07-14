# Encoding: utf-8
# frozen_string_literal: true
require 'forwardable'
require_relative 'card'

module Blackjack
  class Deck
    class OutOfCardsError < StandardError; end

    extend Forwardable
    attr_reader :cards
    def_delegator :@cards, :shuffle!

    def initialize
      @cards = Card::SYMBOLS.keys.map do |suit|
        Card::VALUES.map do |value|
          Card.new(value, suit)
        end
      end.flatten
    end

    def deal!
      raise OutOfCardsError unless @cards.any?
      @cards.shift
    end
  end
end
