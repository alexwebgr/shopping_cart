class Printer
  attr_reader :cart

  def initialize(items)
    @cart = ShoppingCart.new(items)
  end

  def print_receipt
    return 'No items' if cart.empty_cart?
    [
      print_items,
      print_total_tax,
      print_total
    ].join(' ')
  end

  private

  def print_items
    cart.list_items.map { |item| "#{item[0]} #{item[1]}: #{item[2]}" }
  end

  def print_total_tax
    "Sales tax: #{cart.calculate_total_tax}"
  end

  def print_total
    "Total: #{cart.calculate_total}"
  end
end
