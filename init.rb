require './lib/cart_validator'
require './lib/cart_calculator'

cart1 = [
  { 'quantity' => 2, 'product' => 'book', 'category' => 'books', 'price' => '12.49', 'imported' => 'false' },
  { 'quantity' => 1, 'product' => 'music cd', 'category' => 'multimedia', 'price' => '14.99', 'imported' => 'false' },
  { 'quantity' => 1, 'product' => 'chocolate bar', 'category' => 'food', 'price' => '0.85', 'imported' => 'false' }
]

cart2 = [
  { 'quantity' => 1, 'product' => 'box of chocolate', 'category' => 'food', 'price' => '10.00', 'imported' => 'true' },
  { 'quantity' => 1, 'product' => 'bottle of perfume', 'category' => 'cosmetics', 'price' => '47.50',
    'imported' => 'true' }
]

cart3 = [
  { 'quantity' => 1, 'product' => 'bottle of perfume', 'category' => 'cosmetics', 'price' => '27.99',
    'imported' => 'true' },
  { 'quantity' => 1, 'product' => 'bottle of perfume', 'category' => 'cosmetics', 'price' => '18.99',
    'imported' => 'false' },
  { 'quantity' => 1, 'product' => 'packet of headache pills', 'category' => 'medical', 'price' => '9.75',
    'imported' => 'false' },
  { 'quantity' => 3, 'product' => 'box of chocolate', 'category' => 'food', 'price' => '11.25', 'imported' => 'true' }
]

cart = cart1

validator = CartValidator.new(cart)

if validator.validate!
  calculator = CartCalculator.new(cart)
  # calculator.print_cart
  # puts '---------------------------'
  calculator.calculate!

  # calculator.print_receipt

else
  puts validator.errors
end
