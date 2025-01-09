require_relative '../../init'

RSpec.describe CartValidator do
  describe 'validate!' do
    let(:cart) do
      [
        { 'quantity' => 1, 'product' => 'Light Matter', 'price' => '14.25', 'category' => 'Stuff',
          'imported' => 'true' },
        { 'quantity' => 2, 'product' => 'Dark Matter', 'price' => '42.24', 'category' => 'Not Stuff',
          'imported' => 'false' }
      ]
    end

    context 'with a valid cart' do
      it 'returns true' do
        expect(CartValidator.new(cart).validate!).to be true
      end

      context 'with case-insensitive imported flag' do
        it 'returns true when imported is false' do
          cart[0].merge(imported: 'fAlSe')
          expect(CartValidator.new(cart).validate!).to be true
        end

        it 'returns true when imported is true' do
          cart[0].merge(imported: 'tRUe')
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
        invalid_cart = cart.dup
        invalid_cart << { 'quantity' => 1, 'product' => 'Other Matter', 'category' => 'Stuff' }

        cart_validator = CartValidator.new(invalid_cart)

        expect(cart_validator.validate!).to be false
        expect(cart_validator.errors).to include('Cart item 2 invalid. Missing values for: price, imported')
      end

      it 'returns false if a line item product is blank' do
        invalid_cart = cart.dup
        invalid_cart << { 'quantity' => 1, 'product' => '', 'price' => '14.25', 'category' => 'Stuff',
                          'imported' => true }

        cart_validator = CartValidator.new(invalid_cart)

        expect(cart_validator.validate!).to be false
        expect(cart_validator.errors).to include('Cart item 2 product invalid.')
      end

      it 'returns false if a line item category is blank' do
        invalid_cart = cart.dup
        invalid_cart << { 'quantity' => 1, 'product' => 'Laughing Matter', 'price' => '14.25', 'category' => '',
                          'imported' => true }

        cart_validator = CartValidator.new(invalid_cart)

        expect(cart_validator.validate!).to be false
        expect(cart_validator.errors).to include('Cart item 2 category invalid.')
      end

      it 'returns false if a line item quantity is blank' do
        invalid_cart = cart.dup
        invalid_cart << { 'quantity' => '', 'product' => 'Laughing Matter', 'price' => '14.25', 'category' => 'Stuff',
                          'imported' => true }

        cart_validator = CartValidator.new(invalid_cart)

        expect(cart_validator.validate!).to be false
        expect(cart_validator.errors).to include('Cart item 2 quantity invalid.')
      end

      it 'returns false if a line item quantity is non-numeric' do
        invalid_cart = cart.dup
        invalid_cart << { 'quantity' => '10alsl', 'product' => 'No Laughing Matter', 'price' => '14.25',
                          'category' => 'Stuff', 'imported' => true }

        cart_validator = CartValidator.new(invalid_cart)

        expect(cart_validator.validate!).to be false
        expect(cart_validator.errors).to include('Cart item 2 quantity invalid.')
      end

      it 'returns false if a line item price is improperly formatted' do
        invalid_cart = cart.dup
        invalid_cart << { 'quantity' => '10', 'product' => 'No Laughing Matter', 'price' => '14.2',
                          'category' => 'Stuff', 'imported' => true }

        cart_validator = CartValidator.new(invalid_cart)

        expect(cart_validator.validate!).to be false
        expect(cart_validator.errors).to include('Cart item 2 price invalid.')
      end

      it 'returns false if a line item imported flag is improperly formatted' do
        invalid_cart = cart.dup
        invalid_cart << { 'quantity' => '10', 'product' => 'No Laughing Matter', 'price' => '14.2',
                          'category' => 'Stuff', 'imported' => 'bunny' }


        cart_validator = CartValidator.new(invalid_cart)

        expect(cart_validator.validate!).to be false
        expect(cart_validator.errors).to include('Cart item 2 imported flag invalid.')
      end
    end
  end
end
