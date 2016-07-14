# Encoding: utf-8
# frozen_string_literal: true
module Blackjack
  class Card
    include Comparable
    attr_reader :suit, :value

    SYMBOLS = { clubs: '♣', diamonds: '♦', hearts: '♥', spades: '♠' }.freeze
    VALUES = (2..10).to_a.concat(%w(J Q K A)).freeze

    def initialize(value, suit)
      @suit = suit.to_sym
      @value = value
    end

    def to_s
      "#{value}#{symbol}"
    end

    def to_i
      return 11 if value == 'A'
      value.is_a?(Integer) ? value : 10
    end

    def to_cmp
      @intval ||= VALUES.index(value)
    end

    def symbol
      SYMBOLS[@suit]
    end

    def <=>(other)
      to_cmp <=> other.to_cmp
    end
  end
end
