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
      expect(cart.print_receipt).to eq("Book: 12.49: music CD: 16.49: chocolate bar: 0.85 Sales tax: 1.5 Total: 29.83")
    end

    it 'prints the receipt for items with import tax' do
      cart = ShoppingCart.new(Items::IMPORTED)
      expect(cart.print_receipt).to eq("imported box of chocolates: 10.5: imported bottle of perfume: 54.65 Sales tax: 7.65 Total: 65.15")
    end

    it 'prints the receipt for items with import tax and without' do
      cart = ShoppingCart.new(Items::IMPORTED_AND_DOMESTIC)
      expect(cart.print_receipt).to eq("imported bottle of perfume: 32.19: bottle of perfume: 20.89: packet of headache pills: 9.75: imported box of chocolates: 11.8 Sales tax: 6.65 Total: 74.63")
    end
  end
end
