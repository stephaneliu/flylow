require 'rails_helper'

RSpec.describe FareConnectionService do
  let(:origin)      { 'HNL' }
  let(:destination) { 'PDX' }

  describe '.initialize' do
    it { expect(described_class.new(origin, destination)) }

    context 'lowercase parameters' do
      let(:connection) do
        described_class.new(origin.downcase, destination.downcase)
      end
      let(:num_of_travelers) { 4 }
      let(:departure_date)   { 1.day.from_now.strftime('%m/%d/%y') }

      it do
        expect(connection.mechanize).to_not be_nil
        expect(connection.origin).to eq(origin)
        expect(connection.destination).to eq(destination)
        expect(connection.departure_date).to eq(departure_date)
        expect(connection.travelers).to eq(num_of_travelers)
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
