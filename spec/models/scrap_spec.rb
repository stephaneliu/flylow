require 'rails_helper'

describe Scrap do
  let(:origin)      { 'HNL' }
  let(:destination) { 'PDX' }
  let(:connection)  { FareConnectionService.new(origin, destination) }

  describe '.initialize' do
    subject { described_class.new(connection) }

    it 'delegates attributes' do
      expect(subject.origin).to eq(connection.origin)
      expect(subject.destination).to eq(connection.destination)
      expect(subject.travelers).to eq(connection.travelers)
      expect(subject.departure_date).to eq(connection.departure_date)
    end
  end

  describe '.get_days_with_fare' do
    before do
      allow(connection).to receive(:get_content) {
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
      }
    end

    let(:day)        { 15 }
    let(:price)      { 791 }
    let(:high_price) { price + 10 }
    let(:day_class)  { 'Text' }
    let(:fare_class) { 'Fare' }

    context 'when content is as expected' do
      subject { described_class.new(connection).get_days_with_fare }

      it 'obtains days and fare', :focus do
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
