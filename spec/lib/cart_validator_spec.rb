require_relative '../../init'

RSpec.describe CartValidator do
  describe 'validate!' do
    context 'with a valid cart' do
      it 'returns true' do
        cart = [
          { quantity: 1, product: 'Dark Matter', price: '14.25', category: 'Stuff', imported: true }
        ]

        expect(CartValidator.new(cart).validate!).to be true
      end

      context 'with case-insensitive imported flag' do
        it 'returns true when imported is false' do
          cart = [
            { quantity: 1, product: 'Dark Matter', price: '14.25', category: 'Stuff', imported: 'fAlSe' }
          ]

          expect(CartValidator.new(cart).validate!).to be true
        end

        it 'returns true when imported is true' do
          cart = [
            { quantity: 1, product: 'Dark Matter', price: '14.25', category: 'Stuff', imported: 'tRUe' }
          ]

          expect(CartValidator.new(cart).validate!).to be true
        end
      end
    end

    context 'with an invalid cart' do
      it 'returns false if the cart is not an array' do
        cart_validator = CartValidator.new({})
        expect(cart_validator.validate!).to be false
        expect(cart_validator.errors).to include('Invalid cart')
      end

      it 'returns false if a line item is missing keys' do
        cart = [
          { quantity: 1, product: 'Dark Matter', price: '14.25', category: 'Stuff', imported: true },
          { quantity: 1, product: 'Something', category: 'Stuff' }
        ]

        cart_validator = CartValidator.new(cart)

        expect(cart_validator.validate!).to be false
        expect(cart_validator.errors).to include('Cart item 1 invalid. Missing values for: price, imported')
      end

      it 'returns false if a line item product is blank' do
        cart = [
          { quantity: 1, product: '', price: '14.25', category: 'Stuff', imported: true }
        ]

        cart_validator = CartValidator.new(cart)

        expect(cart_validator.validate!).to be false
        expect(cart_validator.errors).to include('Cart item 0 product invalid.')
      end

      it 'returns false if a line item category is blank' do
        cart = [
          { quantity: 1, product: 'Things', price: '14.25', category: '', imported: true }
        ]

        cart_validator = CartValidator.new(cart)

        expect(cart_validator.validate!).to be false
        expect(cart_validator.errors).to include('Cart item 0 category invalid.')
      end

      it 'returns false if a line item quantity is blank' do
        cart = [
          { quantity: '', product: 'Things', price: '14.25', category: '', imported: true }
        ]

        cart_validator = CartValidator.new(cart)

        expect(cart_validator.validate!).to be false
        expect(cart_validator.errors).to include('Cart item 0 quantity invalid.')
      end

      it 'returns false if a line item quantity is non-numeric' do
        cart = [
          { quantity: '10alsl', product: 'Things', price: '14.25', category: '', imported: true }
        ]

        cart_validator = CartValidator.new(cart)

        expect(cart_validator.validate!).to be false
        expect(cart_validator.errors).to include('Cart item 0 quantity invalid.')
      end

      it 'returns false if a line item price is improperly formatted' do
        cart = [
          { quantity: '10', product: 'Things', price: '14.5', category: '', imported: true }
        ]

        cart_validator = CartValidator.new(cart)

        expect(cart_validator.validate!).to be false
        expect(cart_validator.errors).to include('Cart item 0 price invalid.')
      end

      it 'returns false if a line item imported flag is improperly formatted' do
        cart = [
          { quantity: '10', product: 'Things', price: '14.5', category: '', imported: 'duck' }
        ]

        cart_validator = CartValidator.new(cart)

        expect(cart_validator.validate!).to be false
        expect(cart_validator.errors).to include('Cart item 0 imported flag invalid.')
      end
    end
  end
end
