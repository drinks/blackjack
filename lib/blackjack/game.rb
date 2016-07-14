# Encoding: utf-8
# frozen_string_literal: true
require_relative 'deck'
require_relative 'hand'

module Blackjack
  class Game
    attr_reader :deck, :dealer_hand, :player_hand

    DEALER_HIT_THRESHOLD = 17
    COMPUTER_LAG = 0.5

    def initialize
      @deck = Deck.new
      @deck.shuffle!
      @dealer_hand = Hand.new(@deck)
      @player_hand = Hand.new(@deck)
    end

    def dealer_status
      hand_ary = dealer_hand.cards.map(&:to_s)
      hand_ary[-1] = '?' unless player_hand.final?
      "[Dealer] #{hand_ary.join(' ')}"
    end

    def player_status
      "[Player] #{player_hand.cards.map(&:to_s).join(' ')}"
    end

    def play!
      clear_screen
      puts welcome_message
      prompt_for_move until player_hand.final?
      puts "Player has #{player_hand.outcome}\n\n"

      play_dealer_hand
      puts "Dealer has #{dealer_hand.outcome}"

      print_outcome
    end

    def outcome
      if dealer_hand > player_hand
        :dealer
      elsif dealer_hand < player_hand
        :player
      elsif dealer_hand.bust? && player_hand.bust?
        :dealer
      else
        :push
      end
    end

    def welcome_message
      "\n♣ ♦ ♥ ♠   BLACKJACK   ♠ ♥ ♦ ♣\n\n"
    end

    private

    def clear_screen
      system('clear') || system('cls')
    end

    def prompt_for_move
      puts('Bust.') && return if player_hand.bust?
      print_status
      puts 'What would you like to do? (h)it, (s)tay'
      print '> '
      handle_move(STDIN.gets)
    end

    def handle_move(move)
      move.strip!
      if move.scan(/h(?:it)?/).any?
        player_hand.hit!
      elsif move.scan(/s(?:tay)?/).any?
        player_hand.stay!
      end
    end

    def play_dealer_hand
      while dealer_hand.value < DEALER_HIT_THRESHOLD && !dealer_hand.bust?
        sleep COMPUTER_LAG
        print_status
        puts 'Dealer hits.'
        dealer_hand.hit!
      end
      sleep COMPUTER_LAG
      print_status
    end

    def print_status
      puts dealer_status
      puts player_status
      puts
    end

    def print_outcome
      if outcome.to_sym == :push
        puts 'Push.'
      else
        puts "#{outcome.to_s.slice(0, 1).upcase +
                outcome.to_s.slice(1..-1)} wins!"
      end
    end
  end
end
