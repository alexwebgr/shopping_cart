# frozen_string_literal: true

require 'spec_helper'
require '../app/shopping_cart'

Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), 'fixtures')) + "/**/*.rb"].each do |file|
  require file
end

RSpec.describe ShoppingCart, type: :service do
  describe 'When I purchase items I receive a receipt which' do

    describe 'lists the name of all the items and their price (including tax)' do
      context 'when they are domestic' do
        let(:cart_tax_free) { ShoppingCart.new(Items::DOMESTIC_TAX_FREE) }
        let(:cart) { ShoppingCart.new(Items::DOMESTIC) }

        it 'applies no tax to essential items like books, food, and medical products' do
          expect(cart_tax_free.list_items).to eq([[1, "Book", 12.49], [1, "packet of headache pills", 9.75], [1, "chocolate bar", 0.85]])
        end

        it 'applies 10% tax to all items except essential ones' do
          expect(cart.list_items).to eq([[1, "Book", 12.49], [1, "music CD", 16.49], [1, "chocolate bar", 0.85]])
        end
      end

      context 'when they are imported' do
        let(:cart) { ShoppingCart.new(Items::IMPORTED) }

        it 'applies an additional 5% on all items' do
          expect(cart.list_items).to eq([[1, "imported box of chocolates", 10.5], [1, "imported bottle of perfume", 54.65]])
        end
      end
    end

    describe 'lists the total amounts of sales taxes paid' do
      context 'when they are domestic' do
        let(:cart_tax_free) { ShoppingCart.new(Items::DOMESTIC_TAX_FREE) }
        let(:cart) { ShoppingCart.new(Items::DOMESTIC) }

        it 'applies no tax to essential items like books, food, and medical products' do
          expect(cart_tax_free.calculate_total_tax).to eq(0.0)
        end

        it 'applies 10% tax to all items except essential ones' do
          expect(cart.calculate_total_tax).to eq(1.50)
        end
      end

      context 'when they are imported' do
        let(:cart) { ShoppingCart.new(Items::IMPORTED) }

        it 'applies an additional 5% on all items' do
          expect(cart.calculate_total_tax).to eq(7.65)
        end
      end
    end

    describe 'lists the total cost of the items' do
      context 'when they are domestic' do
        let(:cart_tax_free) { ShoppingCart.new(Items::DOMESTIC_TAX_FREE) }
        let(:cart) { ShoppingCart.new(Items::DOMESTIC) }

        it 'applies no tax to essential items like books, food, and medical products' do
          expect(cart_tax_free.calculate_total).to eq(23.09)
        end

        it 'applies 10% tax to all items except essential ones' do
          expect(cart.calculate_total).to eq(29.83)
        end
      end

      context 'when they are imported' do
        let(:cart) { ShoppingCart.new(Items::IMPORTED) }

        it 'applies an additional 5% on all items' do
          expect(cart.calculate_total).to eq(65.15)
        end
      end
    end
  end
end