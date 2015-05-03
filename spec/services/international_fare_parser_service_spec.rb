require 'spec_helper'

RSpec.describe InternationalFareParserService do
  describe '.initialize' do
    subject(:parser) { described_class.new }
    specify do
      expect(parser.parser)
    end
  end

  describe '.parse' do
    let(:content) do
      { Availabilities: [
        { PriceTabs: [
          { Price: 388.20, TabDate: "05/01/2015" },
          { Price: 388.20, TabDate: "05/02/2015" },
          { Price: 388.20, TabDate: "05/03/2015" },
          { Price: "#{departure_price}", TabDate: "#{departure_date}" },
          { Price: 388.20, TabDate: "05/05/2015" },
          { Price: 388.20, TabDate: "05/06/2015" },
          { Price: 388.20, TabDate: "05/07/2015" }
        ] },
        { PriceTabs: [
          { Price: 388.20, TabDate: "05/02/2015" },
          { Price: 388.20, TabDate: "05/03/2015" },
          { Price: 388.20, TabDate: "05/04/2015" },
          { Price: "#{return_price}", TabDate: "#{return_date}" },
          { Price: 388.20, TabDate: "05/06/2015" },
          { Price: 388.20, TabDate: "05/07/2015" },
          { Price: 388.20, TabDate: "05/08/2015" }
        ] }
      ] }.to_json
    end
    let(:departure_date)  { "05/04/2015" }
    let(:departure_price) { 1000 }
    let(:return_date)     { "05/05/2015" }
    let(:return_price)    { 2000 }

    context 'when content is as expected' do
      let(:departure_date)  { "08/16/2020" }
      let(:departure_price) { 1000 }
      let(:return_date)     { "11/18/2020" }
      let(:return_price)    { 2000 }
      subject(:days_with_fares) { described_class.new.parse(content) }

      it 'obtains days and fare' do
        expect(days_with_fares[:departure].keys)
          .to include(Date.strptime(departure_date, "%m/%d/%Y"))
        expect(days_with_fares[:departure].values).to include(departure_price)
        expect(days_with_fares[:return].keys).to include(Date.strptime(return_date, "%m/%d/%Y"))
        expect(days_with_fares[:return].values).to include(return_price)
      end
    end

    context 'when content' do
      context 'has unexpected date data' do
        let(:departure_date) { "08-16-2020" }

        it 'logs unexpected date format to logger' do
          expect(Rails.logger).to receive(:error)
            .with(/Unexpected date format for #{described_class.new.class}:/)
          described_class.new.parse(content)
        end

        it 'does not include price to parsed data' do
          expect(described_class.new.parse(content)[:departure].keys).to_not include(nil)
        end
      end
    end

    context 'has unexepcted price data' do
      let(:departure_price)     { "non_parseable_integer" }
      subject(:days_with_fares) { described_class.new.parse(content) }

      specify { expect(days_with_fares[:departure].values).to include 0.0 }
    end
  end
end
