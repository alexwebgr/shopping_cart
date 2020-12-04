# frozen_string_literal: true

require 'spec_helper'
require '../app/shopping_cart'

Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), 'fixtures')) + "/**/*.rb"].each do |file|
  require file
end

RSpec.describe ShoppingCart, type: :service do
  describe 'items with no import tax' do
    let(:cart) { ShoppingCart.new(Items::DOMESTIC) }

    it 'return the list of items' do
      expect(cart.list_items).to eq([[1, "Book", 12.49], [1, "music CD", 16.49], [1, "chocolate bar", 0.85]])
    end

    it 'return the total tax' do
      expect(cart.calculate_total_tax).to eq(1.50)
    end

    it 'return the total' do
      expect(cart.calculate_total).to eq(29.83)
    end
  end

  describe 'items with import tax' do
    let(:cart) { ShoppingCart.new(Items::IMPORTED) }

    it 'return the list of items' do
      expect(cart.list_items).to eq([[1, "imported box of chocolates", 10.5], [1, "imported bottle of perfume", 54.65]])
    end

    it 'return the total tax' do
      expect(cart.calculate_total_tax).to eq(7.65)
    end

    it 'return the total' do
      expect(cart.calculate_total).to eq(65.15)
    end
  end

  describe 'items with import tax and without' do
    let(:cart) { ShoppingCart.new(Items::IMPORTED_AND_DOMESTIC) }

    it 'return the list of items' do
      expect(cart.list_items).to eq([[1, "imported bottle of perfume", 32.19], [1, "bottle of perfume", 20.89], [1, "packet of headache pills", 9.75], [1, "imported box of chocolates", 11.8]])
    end

    it 'return the total tax' do
      expect(cart.calculate_total_tax).to eq(6.65)
    end

    it 'return the total' do
      expect(cart.calculate_total).to eq(74.63)
    end
  end

  describe 'items with multiple quantities' do
    let(:cart) { ShoppingCart.new(Items::MULTIPLE_QUANTITIES) }

    it 'return the list of items' do
      expect(cart.list_items).to eq([[1, "Book", 12.49], [2, "music CD", 32.98], [3, "chocolate bar", 2.55]])
    end

    it 'return the total tax' do
      expect(cart.calculate_total_tax).to eq(3.00)
    end

    it 'return the total' do
      expect(cart.calculate_total).to eq(48.02)
    end
  end
end
