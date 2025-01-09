require 'json'
require './lib/cart_validator'
require './lib/cart_calculator'

cart = JSON.parse(File.read(ARGV[0]))

validator = CartValidator.new(cart)

if validator.validate!
  calculator = CartCalculator.new(cart)
  calculator.calculate!

  puts 'Your Input Cart:'
  calculator.print_cart
  puts ''

  puts 'Your Output Cart:'
  calculator.print_receipt
else
  puts validator.errors
end
