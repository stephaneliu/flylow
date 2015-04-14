require 'rails_helper'

RSpec.describe FareConnectionService do
  let(:origin)      { 'HNL' }
  let(:destination) { 'PDX' }

  describe '.initialize' do
    let(:connection) do
      described_class.new(origin.downcase, destination.downcase)
    end
    let(:num_of_travelers) { 4 }
    let(:departure_date)   { 1.day.from_now }

    it { expect(described_class.new(origin, destination)) }

    context 'readers' do
      it do
        expect(connection.mechanize).to_not be_nil
        expect(connection.origin).to eq(origin)
        expect(connection.destination).to eq(destination)
        expect(connection.travelers).to eq(num_of_travelers)
      end
    end

    context 'accessor' do
      it do
        expect(connection.departure_date)
          .to eq(departure_date.to_date)

        three_months              = 3.months.from_now
        connection.departure_date = three_months

        expect(connection.departure_date)
          .to eq(three_months)
      end
    end
  end

  describe '.get_page', :vcr do
    subject { described_class.new(origin, destination).get_content }

    context 'with origin HNL and destination PDX (vcr cassettes)' do
      it 'returns parsable nokogiri html document object' do
        expect(subject.css('td.CalendarDayCheapest')).to be_present
      end
    end
  end
end
