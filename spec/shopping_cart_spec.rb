# frozen_string_literal: true

require 'spec_helper'
require '../shopping_cart'

Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), 'fixtures')) + "/**/*.rb"].each do |file|
  require file
  end

RSpec.describe ShoppingCart, type: :service do
  describe '#print_receipt' do
    it 'prints the receipt for items with no import tax' do
      cart = ShoppingCart.new(Items::DOMESTIC)
      # expect(cart.print_receipt).to eq('book: 12.49\n music cd: 16.49\n chocolate bar: 0.85Sales Taxes: 1.50\n Total: 29.83')
      expect(cart.print_receipt).to eq( [[["Book", 12.49], ["music CD", 16.49], ["chocolate bar", 0.85]], 1.50, 29.83])
    end

    it 'prints the receipt for items with import tax' do
      cart = ShoppingCart.new(Items::IMPORTED)
      # expect(cart.print_receipt).to eq('imported box of chocolates: 10.50 imported bottle of perfume: 54.65 Sales Taxes: 7.65 Total: 65.15')
      expect(cart.print_receipt).to eq([[["imported box of chocolates", 10.50], ["imported bottle of perfume", 54.65]], 7.65, 65.15])
    end

    it 'prints the receipt for items with import tax and without' do
      cart = ShoppingCart.new(Items::IMPORTED_AND_DOMESTIC)
      # expect(cart.print_receipt).to eq('imported bottle of perfume: 32.19 bottle of perfume: 20.89 packet of headache pills: 9.75 imported box of chocolates: 11.85 Sales Taxes: 6.70 Total: 74.68')
      expect(cart.print_receipt).to eq([[["imported bottle of perfume", 32.19], ["bottle of perfume", 20.89], ["packet of headache pills", 9.75], ["imported box of chocolates", 11.80]], 6.65, 74.63])
    end
  end
end
