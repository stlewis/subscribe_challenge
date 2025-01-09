class CartValidator
  attr_reader :errors

  def initialize(cart)
    @cart = cart
    @errors = []
  end

  def validate!
    @errors << 'Invalid cart' unless @cart.is_a?(Array)

    @cart.each_with_index do |line_item, idx|
      missing_keys = %i[quantity product price category imported] - line_item.compact.keys

      @errors << "Cart item #{idx} invalid. Missing values for: #{missing_keys.join(', ')}" if missing_keys.any?
      @errors << "Cart item #{idx} product invalid." if line_item[:product].to_s.empty?
      @errors << "Cart item #{idx} category invalid." if line_item[:category].to_s.empty?
      @errors << "Cart item #{idx} quantity invalid." unless line_item[:quantity].to_s =~ /^\d+$/
      @errors << "Cart item #{idx} price invalid." unless line_item[:price].to_s =~ /^\d+\.\d{2}$/
      @errors << "Cart item #{idx} imported flag invalid." unless line_item[:imported].to_s =~ /(true|false)/i
    end

    return false if @errors.any?

    true
  end
end
