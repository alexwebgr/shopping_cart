# frozen_string_literal: true

require 'spec_helper'
require '../shopping_cart'

Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), 'fixtures')) + "/**/*.rb"].each do |file|
  require file
end

RSpec.describe ShoppingCart, type: :service do
  describe 'items with no import tax' do
    let(:cart) { ShoppingCart.new(Items::DOMESTIC) }

    it 'returns the list of items' do
      expect(cart.list_items).to eq([["Book", 12.49], ["music CD", 16.49], ["chocolate bar", 0.85]])
    end

    it 'returns the total tax' do
      expect(cart.calculate_total_tax).to eq(1.50)
    end

    it 'returns the total' do
      expect(cart.calculate_total).to eq(29.83)
    end
  end

  describe 'items with import tax' do
    let(:cart) { ShoppingCart.new(Items::IMPORTED) }

    it 'returns the list of items' do
      expect(cart.list_items).to eq([["imported box of chocolates", 10.5], ["imported bottle of perfume", 54.65]])
    end

    it 'returns the total tax' do
      expect(cart.calculate_total_tax).to eq(7.65)
    end

    it 'returns the total' do
      expect(cart.calculate_total).to eq(65.15)
    end
  end

  describe 'items with import tax and without' do
    let(:cart) { ShoppingCart.new(Items::IMPORTED_AND_DOMESTIC) }

    it 'returns the list of items' do
      expect(cart.list_items).to eq([["imported bottle of perfume", 32.19], ["bottle of perfume", 20.89], ["packet of headache pills", 9.75], ["imported box of chocolates", 11.8]])
    end

    it 'returns the total tax' do
      expect(cart.calculate_total_tax).to eq(6.65)
    end

    it 'returns the total' do
      expect(cart.calculate_total).to eq(74.63)
    end
  end
end
