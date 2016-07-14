# Encoding: utf-8
# frozen_string_literal: true
module Blackjack
  class Hand
    include Comparable
    attr_reader :cards

    BUST_POINT_VALUE = -1
    TROLLEY_POINT_VALUE = 50
    BLACKJACK_POINT_VALUE = 100

    def initialize(deck)
      @deck = deck
      @cards = []
      @final = false
      2.times do
        hit!
      end
    end

    def value
      value = cards.inject(0) do |sum, card|
        sum + card.to_i
      end
      number_of('A').times do
        value -= 10 if value > 21
      end
      value
    end

    def outcome
      if bust?
        "busted with #{value}."
      elsif blackjack?
        'Blackjack!'
      elsif trolley?
        'a 5-Card Trolley!'
      else
        "#{value}."
      end
    end

    def hit!
      @cards << @deck.deal! unless bust?
    end

    def stay!
      @final = true
    end

    def bust?
      value > 21
    end

    def final?
      @final = true if bust? || blackjack? || trolley?
      @final
    end

    def blackjack?
      value == 21 && @cards.size == 2
    end

    def trolley?
      !bust? && @cards.size >= 5
    end

    def to_cmp
      if bust?
        BUST_POINT_VALUE
      elsif blackjack?
        BLACKJACK_POINT_VALUE
      elsif trolley?
        TROLLEY_POINT_VALUE
      else
        value
      end
    end

    def <=>(other)
      to_cmp <=> other.to_cmp
    end

    private

    def number_of(value)
      cards.select { |card| card.value == value }.size
    end
  end
end
