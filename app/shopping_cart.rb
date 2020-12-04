class ShoppingCart
  def initialize(items)
    @items = items
  end

  def list_items
    items.values.map do |item|
      [item[:quantity], item[:title], calculate_price(item[:id])]
    end
  end

  def calculate_total_tax
    items.values.map { |item| calculate_tax(item[:id]) }.sum
  end

  def calculate_total
    items.values.map { |item| calculate_price(item[:id]) }.sum
  end

  def empty_cart?
    items.empty?
  end

  private
  attr_reader :items

  def calculate_tax(item_id)
    item = items[item_id.to_sym]
    round_num((((item[:tax] + item[:import_tax]) * item[:price]) / 100), 20)
  end

  def calculate_price(item_id)
    item = items[item_id.to_sym]
    (item[:price] + calculate_tax(item[:id])).round(2)
  end

  def round_num(num, precision)
    (num * precision).round / precision.to_f
  end
end
