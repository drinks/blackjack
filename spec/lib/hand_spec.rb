# frozen_string_literal: true
require 'spec_helper'

describe Blackjack::Hand do
  let(:deck) { Blackjack::Deck.new }
  let(:cards) do
    [Blackjack::Card.new(4, :spades),
     Blackjack::Card.new('A', :spades)]
  end
  let(:blackjack_cards) do
    [Blackjack::Card.new('A', :spades),
     Blackjack::Card.new('J', :spades)]
  end
  let(:busted_cards) do
    [Blackjack::Card.new('J', :spades),
     Blackjack::Card.new('Q', :spades),
     Blackjack::Card.new(2, :spades)]
  end
  let(:trolley_cards) { (0..4).map { |_| Blackjack::Card.new('A', :spades) } }
  subject { described_class.new(deck) }

  context 'a new instance' do
    it 'references the given game deck' do
      expect(subject.instance_variable_get('@deck')).to eql(deck)
    end

    it 'initializes a cards array with 2 cards from the deck' do
      expect(subject.cards.length).to eql(2)
    end

    it 'is not final' do
      expect(subject.final?).to be(false)
    end
  end

  context 'with cards' do
    before(:each) do
      subject.instance_variable_set('@cards', cards)
    end

    describe '#value' do
      it 'totals its value' do
        expect(subject.value).to eql(15)
      end

      context 'aces can be 1 or 11' do
        let(:cards) { (0..3).map { |_| Blackjack::Card.new('A', :spades) } }
        it "doesn't bust with 4 aces" do
          expect(subject.value).to eql(14)
        end
      end

      context 'values over 21' do
        let(:cards) { busted_cards }
        it { expect(subject.value).to eql(22) }
      end
    end

    describe '#hit!' do
      let(:cards) do
        [Blackjack::Card.new('A', :spades), Blackjack::Card.new('A', :spades)]
      end
      it 'adds a card to the hand and removes one from the deck' do
        subject.hit!
        expect(subject.cards.length).to eql(3)
        expect(deck.cards.length).to eql(49)
      end

      context 'when busted' do
        let(:cards) { busted_cards }
        it 'does not draw a card' do
          subject.hit!
          expect(subject.cards.length).to eql(3)
          expect(deck.cards.length).to eql(50)
        end
      end
    end

    describe '#stay!' do
      it 'finalizes the hand' do
        subject.stay!
        expect(subject.final?).to be(true)
      end
    end

    describe '#bust?' do
      context 'when under 21' do
        it { expect(subject.bust?).to be(false) }
      end

      context 'when 21' do
        let(:cards) { blackjack_cards }
        it { expect(subject.bust?).to be(false) }
      end

      context 'when over 21' do
        let(:cards) { busted_cards }
        it { expect(subject.bust?).to be(true) }
      end
    end

    describe '#final?' do
      context 'when under 21' do
        it { expect(subject.final?).to be(false) }
      end

      context 'when over 21' do
        let(:cards) { busted_cards }
        it { expect(subject.final?).to be(true) }
      end

      context 'when blackjack' do
        let(:cards) { blackjack_cards }
        it { expect(subject.final?).to be(true) }
      end

      context 'when trolley' do
        let(:cards) { trolley_cards }
        it { expect(subject.final?).to be(true) }
      end
    end

    describe '#blackjack?' do
      context 'when not blackjack' do
        it { expect(subject.blackjack?).to be(false) }
      end

      context 'when blackjack' do
        let(:cards) { blackjack_cards }
        it { expect(subject.blackjack?).to be(true) }
      end
    end

    describe '#trolley?' do
      context 'when not trolley' do
        it { expect(subject.trolley?).to be(false) }
      end

      context 'when busted with 5 cards' do
        let(:cards) { (0..4).map { |_| Blackjack::Card.new('Q', :spades) } }
        it { expect(subject.trolley?).to be(false) }
      end

      context 'when trolley' do
        let(:cards) { trolley_cards }
        it { expect(subject.trolley?).to be(true) }
      end
    end

    describe '#to_cmp' do
      context 'when under 21' do
        it 'returns the numeric value' do
          expect(subject.to_cmp).to eql(15)
        end
      end

      context 'when over 21' do
        let(:cards) { busted_cards }
        it { expect(subject.to_cmp).to eq(-1) }
      end

      context 'when blackjack' do
        let(:cards) { blackjack_cards }
        it { expect(subject.to_cmp).to eql(100) }
      end

      context 'when trolley' do
        let(:cards) { trolley_cards }
        it { expect(subject.to_cmp).to eq(50) }
      end
    end
  end
end
