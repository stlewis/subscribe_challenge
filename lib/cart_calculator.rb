class CartCalculator
  TAX_EXEMPT_CATEGORIES = %w[books food medical].freeze
  TAX_RATE = 0.10
  DUTY_RATE = 0.05

  attr_reader :receipt

  def initialize(cart)
    @cart = cart
    @receipt = { items: [] }
  end

  def calculate!
    cart_total_tax = 0
    cart_grand_total = 0

    @cart.each do |line_item|
      pennies = (line_item['price'].to_f * 100).round(2).to_i

      taxes_and_duties = calculate_taxes_and_duties(line_item)

      line_item_sum = pennies * line_item['quantity'].to_i
      line_item_with_tax = line_item_sum + taxes_and_duties

      cart_total_tax += taxes_and_duties
      cart_grand_total += line_item_with_tax

      decimal_price = (line_item_with_tax / 100.0)
      line_item_formatted_price = format('%.2f', decimal_price)

      @receipt[:items] << line_item.merge('total_price' => line_item_formatted_price)
    end

    total_tax_formatted = format('%.2f', cart_total_tax / 100.0)
    grand_total_formatted = format('%.2f', cart_grand_total / 100.0)

    @receipt[:total_tax] = total_tax_formatted
    @receipt[:grand_total] = grand_total_formatted

    @receipt
  end

  def print_receipt
    @receipt[:items].each do |item|
      puts "#{item['quantity']} #{item['product']}: #{item['total_price']}"
    end
    puts "Sales Taxes: #{@receipt[:total_tax]}"
    puts "Total: #{@receipt[:grand_total]}"
  end

  def print_cart
    @cart.each do |item|
      puts "#{item['quantity']} #{item['product']} at #{item['price']}"
    end
  end

  private

  def calculate_tax(taxable_sum, tax_rate)
    base_tax = taxable_sum * tax_rate

    (base_tax / 5.0).ceil * 5
  end

  def calculate_taxes_and_duties(line_item)
    pennies = (line_item['price'].to_f * 100).round(2).to_i

    calculated_tax = TAX_EXEMPT_CATEGORIES.include?(line_item['category']) ? 0 : calculate_tax(pennies, TAX_RATE)
    calculated_duty = line_item['imported'].downcase == 'true' ? calculate_tax(pennies, DUTY_RATE) : 0

    (calculated_tax * line_item['quantity']) + (calculated_duty * line_item['quantity'])
  end
end
