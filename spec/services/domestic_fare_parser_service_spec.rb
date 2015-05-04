require 'spec_helper'

RSpec.describe DomesticFareParserService do
  subject(:parser)     { described_class.new }
  let(:departure_date) { 1.day.from_now.to_date }

  describe '.initialize' do
    specify { expect(parser.parser).to eq(Nokogiri::HTML) }
  end

  describe '.parse' do
    let(:content) do
      "<td class='CalendarDayDefault'>
          <div class='#{day_class}'>#{day}</div>
          <div class='#{fare_class}'>$#{high_price}</div>
        </td>
        <td class='CalendarDayCheapest'>
          <div class='#{day_class}'>#{day}</div>
          <div class='#{fare_class}'>$#{price}</div>
        </td>"
    end

    let(:day)        { 15 }
    let(:price)      { 791 }
    let(:high_price) { price + 10 }
    let(:day_class)  { 'Text' }
    let(:fare_class) { 'Fare' }

    context 'expecting departure_date to be assigned' do
      specify do
        expect { parser.parse(content) }
          .to raise_error(ArgumentError, "departure_date not assigned")
      end
    end

    context 'departure_date assignment after parse is called' do
      before { parser.departure_date = Time.zone.now.to_date }

      it 'is assigned to nil' do
        parser.parse(content)
        expect(parser.departure_date).to eq(nil)
      end
    end

    context 'when content is as expected' do
      before do
        parser.departure_date = departure_date
        parser.parse(content)
      end

      context 'conforming to inheritted class' do
        context 'departure fares' do
          let(:departing) { true }

          it 'obtains days and fare' do
            expect(parser.fares(departing).keys.map(&:day)).to include day
            expect(parser.fares(departing).values).to include price.to_f
            expect(parser.fares(departing).values).to_not include high_price.to_f
          end
        end

        context 'return fares' do
          let(:departing) { false }

          it 'returns empty hash' do
            expect(parser.fares(departing).keys).to be_blank
            expect(parser.fares(departing).values).to be_blank
          end
        end
      end
    end

    context 'when content is not parseable' do
      before do
        parser.departure_date = Time.zone.now.to_date
        parser.parse(content)
      end

      let(:day_class)  { 'text' }
      let(:fare_class) { 'fare' }

      specify { expect(parser.fares).to be_blank }
    end
  end
end
