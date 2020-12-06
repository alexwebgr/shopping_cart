# frozen_string_literal: true

require 'spec_helper'
require '../app/printer'

Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), 'fixtures')) + "/**/*.rb"].each do |file|
  require file
end

RSpec.describe Printer, type: :service do
  describe 'When I purchase items I receive a receipt which' do
    context 'when there are no items' do
      it 'displays a "No items" message' do
        cart = Printer.new({})
        expect(cart.print_receipt).to eq('No items')
      end
    end

    describe 'lists the name of all the items and their price (including tax), the total cost and total amount of sales taxes paid' do
      context 'when they are domestic' do
        it 'applies no tax to essential items like books, food, and medical products' do
          cart = Printer.new(Items::DOMESTIC_TAX_FREE)
          expect(cart.print_receipt).to eq("1 Book: 12.49 1 packet of headache pills: 9.75 1 chocolate bar: 0.85 Sales tax: 0.0 Total: 23.09")
        end

        it 'applies 10% tax to all items except from the essential ones' do
          cart = Printer.new(Items::DOMESTIC)
          expect(cart.print_receipt).to eq("1 Book: 12.49 1 music CD: 16.49 1 chocolate bar: 0.85 Sales tax: 1.5 Total: 29.83")
        end
      end

      context 'when they are imported' do
        it 'applies an additional 5% on all items' do
          cart = Printer.new(Items::IMPORTED)
          expect(cart.print_receipt).to eq("1 imported box of chocolates: 10.5 1 imported bottle of perfume: 54.65 Sales tax: 7.65 Total: 65.15")
        end
      end

      context 'when they are imported and domestic' do
        it 'applies an additional 5% on all items only to imported ones' do
          cart = Printer.new(Items::IMPORTED_AND_DOMESTIC)
          expect(cart.print_receipt).to eq("1 imported bottle of perfume: 32.19 1 bottle of perfume: 20.89 1 packet of headache pills: 9.75 1 imported box of chocolates: 11.8 Sales tax: 6.65 Total: 74.63")
        end
      end

      context 'when the quantity is greater than one' do
        it 'reflects the quantities for the individual items, the sales tax and total amounts' do
          cart = Printer.new(Items::MULTIPLE_QUANTITIES)
          expect(cart.print_receipt).to eq("1 Book: 12.49 2 music CD: 32.98 3 chocolate bar: 2.55 Sales tax: 3.0 Total: 48.02")
        end
      end
    end
  end
end
