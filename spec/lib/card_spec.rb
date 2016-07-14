# Encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe Blackjack::Card do
  let(:suit) { :spades }
  let(:value) { 'A' }
  subject { described_class.new(value, suit) }

  describe 'delegates' do
    %i(suit value).each do |meth|
      it "responds_to #{meth}" do
        expect { respond_to meth }
      end
    end
  end

  describe '#to_s' do
    it { expect(subject.to_s).to eql('A♠') }
  end

  describe '#to_i' do
    context 'a face card' do
      it { expect(subject.to_i).to eql(11) }
    end

    context 'a number card' do
      let(:value) { 6 }
      it { expect(subject.to_i).to eql(6) }
    end
  end

  describe '#to_cmp' do
    it 'uses the index in the values array' do
      expect(described_class.new(2, suit).to_cmp).to eql(0)
      expect(described_class.new('A', suit).to_cmp).to eql(12)
    end
  end

  describe '#symbol' do
    it { expect(subject.symbol).to eql('♠') }
  end
end
