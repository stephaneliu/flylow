require 'rails_helper'

describe Scrap do
  let(:departure_date) { 1.day.from_now.to_date }

  describe '.initialize' do
    subject { described_class.new(departure_date) }

    it 'delegates attributes' do
      expect(subject.departure_date).to eq(departure_date)
    end
  end

  describe '.parse' do
    let(:content) do
      Nokogiri::HTML::Document.parse("
        <td class='CalendarDayDefault'>
          <div class='#{day_class}'>#{day}</div>
          <div class='#{fare_class}'>$#{high_price}</div>
        </td>
        <td class='CalendarDayCheapest'>
          <div class='#{day_class}'>#{day}</div>
          <div class='#{fare_class}'>$#{price}</div>
        </td>
      ")
    end

    let(:day)        { 15 }
    let(:price)      { 791 }
    let(:high_price) { price + 10 }
    let(:day_class)  { 'Text' }
    let(:fare_class) { 'Fare' }

    context 'when content is as expected', :focus do
      subject { described_class.new(departure_date).parse(content) }

      it 'obtains days and fare' do
        expect(subject.keys.map(&:day)).to include day
        expect(subject.values).to include price.to_f
        expect(subject.values).to_not include high_price.to_f
      end
    end

    context 'when day is not parseable' do
      let(:day_class) { 'text' }

      subject { described_class.new(connection).get_days_with_fare.keys }
      it      { is_expected.to all be_blank }
    end

    context 'when fare is not parseable' do
      let(:fare_class) { 'fare' }

      subject { described_class.new(connection).get_days_with_fare.values }
      it      { is_expected.to all be_blank }
    end
  end
end
