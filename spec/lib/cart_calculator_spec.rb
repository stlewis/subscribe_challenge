require_relative '../../init'

RSpec.describe CartCalculator do
  describe '#calculate!' do
    context 'with tax and duty free items' do
      let(:cart) do
        [
          { 'quantity' => 1, 'product' => 'Frozen Chicken', 'category' => 'food', 'price' => '20.00',
            'imported' => 'false' },
          { 'quantity' => 2, 'product' => 'A Farewell To Arms', 'category' => 'books', 'price' => '18.75',
            'imported' => 'false' }
        ]
      end

      it 'charges the base price only' do
        receipt = CartCalculator.new(cart).calculate!
        cart_total = cart.sum { |line_item| line_item['price'].to_f * line_item['quantity'] }

        formatted_total = format('%.2f', cart_total)
        expect(receipt[:grand_total]).to eq(formatted_total)
      end
    end

    context 'with taxable items' do
      let(:cart) do
        [
          { 'quantity' => 1, 'product' => 'CD Player', 'category' => 'electronics', 'price' => '40.00',
            'imported' => 'false' },
          { 'quantity' => 1, 'product' => 'Armchair', 'category' => 'furniture', 'price' => '150.13',
            'imported' => 'false' }
        ]
      end

      it 'adds 10% tax, rounded to the nearest nickel to each line item and the total' do
        receipt = CartCalculator.new(cart).calculate!

        taxed_totals = cart.map do |line_item|
          pennies = (line_item['price'].to_f * 100).round(2).to_i
          tax_amount = pennies * 0.10
          rounded_tax = (tax_amount / 5.0).ceil * 5
          [pennies + rounded_tax, rounded_tax]
        end

        receipt[:items].each_with_index do |line_item, idx|
          formatted_total = format('%.2f', taxed_totals[idx][0] / 100.0)
          expect(line_item['total_price']).to eq(formatted_total)
        end

        summed_total = format('%.2f', taxed_totals.map(&:first).sum / 100.0)
        summed_tax = format('%.2f', taxed_totals.map(&:last).sum / 100.0)

        expect(receipt[:grand_total]).to eq(summed_total)
        expect(receipt[:total_tax]).to eq(summed_tax)
      end
    end

    context 'with non-duty-free items' do
      let(:cart) do
        [
          { 'quantity' => 1, 'product' => 'Huckleberry Finn', 'category' => 'books', 'price' => '20.00',
            'imported' => 'true' },
          { 'quantity' => 1, 'product' => 'Tom Sawyer', 'category' => 'books', 'price' => '35.00',
            'imported' => 'true' }
        ]
      end

      it 'adds 5% duty, rounded to the nearest nickel to each line item and the total' do
        receipt = CartCalculator.new(cart).calculate!

        duty_totals = cart.map do |line_item|
          pennies = (line_item['price'].to_f * 100).round(2).to_i
          duty_amount = pennies * 0.05
          rounded_duty = (duty_amount / 5.0).ceil * 5
          [pennies + rounded_duty, rounded_duty]
        end

        receipt[:items].each_with_index do |line_item, idx|
          formatted_total = format('%.2f', duty_totals[idx][0] / 100.0)
          expect(line_item['total_price']).to eq(formatted_total)
        end

        summed_total = format('%.2f', duty_totals.map(&:first).sum / 100.0)
        summed_duty = format('%.2f', duty_totals.map(&:last).sum / 100.0)

        expect(receipt[:grand_total]).to eq(summed_total)
        expect(receipt[:total_tax]).to eq(summed_duty)
      end
    end

    context 'with taxable and non-duty-free items' do
      let(:cart) do
        [
          { 'quantity' => 1, 'product' => 'The Matrix', 'category' => 'movies', 'price' => '20.00',
            'imported' => 'true' },
          { 'quantity' => 1, 'product' => 'Ready Player One', 'category' => 'movies', 'price' => '35.00',
            'imported' => 'true' }
        ]
      end

      it 'adds 5% duty and 10% tax rounded to the nearest nickel to each line item and the total' do
        receipt = CartCalculator.new(cart).calculate!

        taxed_totals = cart.map do |line_item|
          pennies = (line_item['price'].to_f * 100).round(2).to_i
          tax_amount = pennies * 0.10
          rounded_tax = (tax_amount / 5.0).ceil * 5

          duty_amount = pennies * 0.05
          rounded_duty = (duty_amount / 5.0).ceil * 5

          combined_tax = rounded_tax + rounded_duty

          [pennies + combined_tax, combined_tax]
        end

        receipt[:items].each_with_index do |line_item, idx|
          formatted_total = format('%.2f', taxed_totals[idx][0] / 100.0)
          expect(line_item['total_price']).to eq(formatted_total)
        end

        summed_total = format('%.2f', taxed_totals.map(&:first).sum / 100.0)
        summed_tax = format('%.2f', taxed_totals.map(&:last).sum / 100.0)

        expect(receipt[:grand_total]).to eq(summed_total)
        expect(receipt[:total_tax]).to eq(summed_tax)
      end
    end
  end
end
