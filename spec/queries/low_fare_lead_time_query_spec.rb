require 'rails_helper'

RSpec.describe LowFareLeadTimeQuery do
  let(:origin)         { create :city, airport_code: 'HNL' }
  let(:destination)    { create :city, airport_code: 'PDX' }
  let(:departure_date) { 1.day.ago.to_date }

  let!(:low_fare) do
    create :fare, origin: origin, destination: destination, departure_date: departure_date,
                  price: 100
  end

  let!(:high_fare) do
    create :fare, origin: origin, destination: destination, departure_date: departure_date,
                  price: 500
  end
  let(:lead_query) do
    described_class.new(origin: origin, destination: destination)
  end

  describe '#initialize' do
    specify do
      expect(lead_query.origin).to eq(origin)
      expect(lead_query.destination).to eq(destination)
    end
  end

  describe '#find_all_for' do
    subject { lead_query.find_all_for(departure_date: departure_date) }

    specify do
      is_expected.to include(low_fare)
      is_expected.to_not include(high_fare)
    end
  end
end
