require 'rails_helper'

RSpec.describe DomesticFareParserService do
  let(:departure_date) { 1.day.from_now.to_date }

  describe '.initialize' do
    context 'without parameters' do
      subject { described_class.new }
      specify { expect(subject.departure_date).to eq(1.day.from_now.to_date) }
    end

    context 'with departure_date' do
      subject { described_class.new(departure_date) }

      it 'attributes' do
        expect(subject.parser)
        expect(subject.departure_date).to eq(departure_date)

        two_months             = 2.months.from_now
        subject.departure_date = two_months

        expect(subject.departure_date).to eq(two_months)
      end
    end
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

    context 'when content is as expected' do
      subject { described_class.new(departure_date).parse(content) }

      it 'obtains days and fare' do
        expect(subject.keys.map(&:day)).to include day
        expect(subject.values).to include price.to_f
        expect(subject.values).to_not include high_price.to_f
      end
    end

    context 'when content is not parseable' do
      let(:day_class) { 'text' }
      let(:fare_class) { 'fare' }

      subject { described_class.new(departure_date).parse(content) }
      it      { is_expected.to all(be_blank) }
      it      { is_expected.to all(be_blank) }
    end
  end
end
