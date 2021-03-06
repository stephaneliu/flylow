require 'rails_helper'

RSpec.describe DomesticFareConnectionService do
  let(:origin)      { 'hnl' }
  let(:destination) { 'pdx' }
  let(:connection)       { described_class.new }

  describe 'inheritence' do
    specify { expect(connection).to be_a BaseConnectionService }
  end

  describe '#new' do
    let(:num_of_travelers) { 4 }
    let(:departure_date)   { 1.day.from_now }

    subject(:connection) { described_class.new }

    specify do
      expect(connection.origin)
      expect(connection.destination)
      expect(connection.mechanize).to_not be_nil
      expect(connection.travelers).to eq(num_of_travelers)
    end
  end

  describe '.get_content', :vcr do
    subject(:content) { described_class.new.get_content(origin, destination, 1.day.from_now) }

    context 'with origin HNL and destination PDX (vcr cassettes)' do
      specify { expect(content).to include('CalendarDayCheapest') }
    end
  end
end
