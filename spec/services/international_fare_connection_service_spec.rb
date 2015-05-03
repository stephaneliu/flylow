require 'rails_helper'

RSpec.describe InternationalFareConnectionService do
  let(:origin)      { 'HNL' }
  let(:destination) { 'HND' }

  describe '.initialize' do
    let(:travelers)      { 4 }
    let(:connection)     { described_class.new(travelers) }
    let(:departure_date) { 1.day.from_now }

    subject(:connection) { described_class.new }

    specify do
      expect(connection.mechanize)
      expect(connection.origin)
      expect(connection.destination)
      expect(connection.departure_date)
      expect(connection.travelers).to eq(travelers)
    end
  end

  describe '.get_content', :vcr do
    subject(:content) { described_class.new.get_content(origin, destination, 1.day.from_now) }

    context 'with origin HNL and destination HND - Tokyo-Haneda (vcr cassettes)' do
      it 'returns parsable nokogiri html document object' do
        expect(content).to include('Availabilities')
        expect(content).to include('PriceTabs')
        expect(content).to include('TabDate')
      end
    end
  end
end
