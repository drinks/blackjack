# Encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe Blackjack::Deck do
  subject { described_class.new }

  context 'creating a new deck' do
    it 'has 52 cards' do
      expect(subject.cards.length).to eql(52)
    end

    it 'has 4 of each value' do
      expect(subject.cards.select { |c| c.value == 5 }.length).to eql(4)
      expect(subject.cards.select { |c| c.value == 'J' }.length).to eql(4)
    end

    it 'has 13 of each suit' do
      expect(subject.cards.select { |c| c.suit == :spades }.length).to eql(13)
    end

    it 'starts with the cards ordered by suit and value' do
      expect(subject.cards.first.to_s).to eql('2♣')
      expect(subject.cards.last.to_s).to eql('A♠')
      expect(subject.cards.first(13).map(&:to_cmp)).to eql((0..12).to_a)
    end
  end

  describe '#shuffle!' do
    before do
      subject.shuffle!
    end

    it 'shuffles the deck' do
      expect(subject.cards.first(13).map(&:to_cmp)).not_to eql((0..12).to_a)
    end
  end

  describe '#deal!' do
    it 'removes and returns the first card in the deck' do
      expect(subject.deal!.to_s).to eql('2♣')
      expect(subject.deal!.to_s).to eql('3♣')
      expect(subject.cards.length).to eql(50)
    end

    it 'raises an error when out of cards' do
      52.times { subject.deal! }
      expect { subject.deal! }.to raise_error(Blackjack::Deck::OutOfCardsError)
    end
  end
end
