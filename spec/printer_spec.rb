# frozen_string_literal: true

require 'spec_helper'
require '../app/printer'

Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), 'fixtures')) + "/**/*.rb"].each do |file|
  require file
end

RSpec.describe Printer, type: :service do
  describe '#print_receipt' do
    it 'prints a message when there are no items' do
      cart = Printer.new({})
      expect(cart.print_receipt).to eq('No items')
    end

    it 'prints the receipt for items with no import tax' do
      cart = Printer.new(Items::DOMESTIC)
      expect(cart.print_receipt).to eq("1 Book: 12.49 1 music CD: 16.49 1 chocolate bar: 0.85 Sales tax: 1.5 Total: 29.83")
    end

    it 'prints the receipt for items with import tax' do
      cart = Printer.new(Items::IMPORTED)
      expect(cart.print_receipt).to eq("1 imported box of chocolates: 10.5 1 imported bottle of perfume: 54.65 Sales tax: 7.65 Total: 65.15")
    end

    it 'prints the receipt for items with import tax and without' do
      cart = Printer.new(Items::IMPORTED_AND_DOMESTIC)
      expect(cart.print_receipt).to eq("1 imported bottle of perfume: 32.19 1 bottle of perfume: 20.89 1 packet of headache pills: 9.75 1 imported box of chocolates: 11.8 Sales tax: 6.65 Total: 74.63")
    end

    it 'prints the receipt with multiple items' do
      cart = Printer.new(Items::MULTIPLE_QUANTITIES)
      expect(cart.print_receipt).to eq("1 Book: 12.49 2 music CD: 32.98 3 chocolate bar: 2.55 Sales tax: 3.0 Total: 48.02")
    end
  end
end
