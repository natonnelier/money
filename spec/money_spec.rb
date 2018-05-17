require './spec/spec_helper'

RSpec.describe Money do
  before do
    Money::Money.conversion_rates('EUR', {
      'USD'     => 1.11,
      'Bitcoin' => 0.0047
    })
  end

  describe "#settings" do
    it "sets default currency to EUR" do
      expect(Money::Money.default_currency).to eq("EUR")
    end
  end

  describe "instance methods" do
    let(:money) { Money::Money.new(50, 'EUR')}

    describe "#initialize" do
      it "creates object with correspondent attributes" do
        expect(money.amount).to eq(50)
        expect(money.currency).to eq('EUR')
      end
    end

    describe "#inspect" do
      it "responds with formated data" do
        expect(money.inspect).to eq("50.00 EUR")
      end
    end

    describe "#convert_to" do
      context "when object's currency is same as default" do
        let(:money_in_usd) { money.convert_to('USD') }

        it "responds with proper Money object" do
          expect(money_in_usd.class).to eq(Money::Money)
          expect(money_in_usd.inspect).to eq("55.50 USD")
        end
      end

      context "when object's currency differs from default" do
        let(:money_in_bitcoin) { Money::Money.new(1, 'Bitcoin') }
        let(:money_in_usd) { money_in_bitcoin.convert_to('USD') }

        it "responds with correct value" do
          expect(money_in_usd.inspect).to eq("236.17 USD")
        end
      end
    end

    describe "#addition and substraction" do
      context "when both objects have same currency" do
        let(:money_in_eur) { Money::Money.new(20, 'EUR') }

        it "#+ should add amounts" do
          money_sum = money + money_in_eur
          expect(money_sum.inspect).to eq("70.00 EUR")
        end

        it "#- should rest amounts" do
          money_subs = money - money_in_eur
          expect(money_subs.inspect).to eq("30.00 EUR")
        end
      end

      context "when objects have different currency" do
        let(:money_in_usd) { Money::Money.new(20, 'USD') }

        it "#+ should add amounts in first objects currency" do
          money_sum = money + money_in_usd
          expect(money_sum.inspect).to eq("68.02 EUR")
        end

        it "#- should rest amounts in first objects currency" do
          money_subs = money - money_in_usd
          expect(money_subs.inspect).to eq("31.98 EUR")
        end
      end

    end

    describe "#multiplication and division" do
      let(:money_in_usd) { Money::Money.new(20, 'USD') }

      describe "# *" do
        it "should multiply objects amount keeping same currency" do
          expect((money_in_usd * 3).inspect).to eq("60.00 USD")
          expect((money * 3).inspect).to eq("150.00 EUR")
        end
      end

      describe "# /" do
        it "should divide objects amount keeping same currency" do
          expect((money_in_usd / 2).inspect).to eq("10.00 USD")
          expect((money / 2).inspect).to eq("25.00 EUR")
        end
      end
    end

    describe "comparissons" do
      describe "# ==" do
        let(:money_in_usd) { money.convert_to('USD') }

        it "should return true when conversion returns same values" do
          expect(money == money_in_usd).to be_truthy
        end
      end

      describe "# <" do
        let(:money_in_usd) { Money::Money.new(40, 'USD')}

        it "should return true when converted values present larger amount on right" do
          expect(money_in_usd < money).to be_truthy
        end
      end

      describe "# >" do
        let(:money_in_usd) { Money::Money.new(60, 'USD')}

        it "should return true when converted values present larger amount on left" do
          expect(money_in_usd > money).to be_truthy
        end
      end
    end
    
    describe "update conversion rates" do
        before do
          Money::Money.conversion_rates('USD',{'EUR' => 0.89})
        end
        
        context "when money is in USD" do
          let(:money_in_usd) { Money::Money.new(60, 'USD') }
            
          it "sets the money object correctly" do
            expect(money_in_usd.class).to eq(Money::Money)
            expect(money_in_usd.inspect).to eq("60.00 USD")
          end
          
          it "should convert to EUR with the proper values" do
            expect(money_in_usd.convert_to('EUR').amount).to eq(60*0.89)
          end
        end
    end
  end
end
