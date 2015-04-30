require 'rails_helper'
RSpec.describe DomesticFareConnectionService do
  let(:origin)      { 'HNL' }
  let(:destination) { 'PDX' }

  describe '.initialize' do
    let(:connection)       { described_class.new }
    let(:num_of_travelers) { 4 }
    let(:departure_date)   { 1.day.from_now }

    it { expect(described_class.new) }

    context 'readers' do
      it do
        expect(connection.mechanize).to_not be_nil
        expect(connection.travelers).to eq(num_of_travelers)
      end
    end
  end

  describe '.get_content', :vcr do
    subject do
      described_class.new.get_content(origin, destination,
                                      1.day.from_now)
    end

    context 'with origin HNL and destination PDX (vcr cassettes)' do
      it 'returns parsable nokogiri html document object' do
        expect(subject.css('td.CalendarDayCheapest')).to be_present
      end
    end
  end
end
