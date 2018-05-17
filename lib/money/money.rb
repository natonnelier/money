module Money
  class Money
    attr_accessor :amount, :currency

    class << self
      attr_accessor :default_currency, :rates

      def conversion_rates(default_currency, rates)
        @default_currency = default_currency
        @rates = rates.merge({ default_currency => 1 })
      end
    end

    def initialize(amount, currency)
      @amount = Float(amount)
      @currency = currency

      validate_currency!(currency)
    end

    def inspect
      "#{sprintf('%.2f', @amount)} #{@currency}"
    end

    def convert_to currency
      validate_currency!(currency)
      amount =  (amount_in_default_currency * rates[currency]).round(4)
      self.class.new(amount, currency)
    end

    def + (other)
      other_amount = other_to_currency(other).amount
      self.class.new(@amount + other_amount, @currency)
    end

    def - (other)
      other_amount = other_to_currency(other).amount
      self.class.new(@amount - other_amount, @currency)
    end

    def / (num)
      self.class.new(@amount / num, @currency)
    end

    def * (num)
      self.class.new(@amount * num, @currency)
    end

    def == (other)
      other_to_currency(other).amount == @amount
    end

    def < (other)
      @amount < other_to_currency(other).amount
    end

    def > (other)
      @amount > other_to_currency(other).amount
    end

    private
    def other_to_currency other
      other.currency == @currency ? other : other.convert_to(@currency)
    end

    def amount_in_default_currency
      return @amount if @currency == default_currency
      @amount / rates[@currency]
    end

    def rates
      @rates ||= self.class.rates
    end

    def default_currency
      @default_currency ||= self.class.default_currency
    end

    def validate_currency! currency
      raise ArgumentError, "#{currency} is no a valid currency" if rates[currency].nil?
    end

  end
end
