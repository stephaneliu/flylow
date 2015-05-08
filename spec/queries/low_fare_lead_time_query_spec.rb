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
  let(:lead_time) do
    described_class.new(origin: origin, destination: destination, departure_date: departure_date)
  end

  describe '#initialize' do
    specify do
      expect(lead_time.origin).to eq(origin)
      expect(lead_time.destination).to eq(destination)
      expect(lead_time.departure_date).to eq(departure_date)
    end
  end

  describe '#find_all' do
    subject { lead_time.find_all }

    specify do
      is_expected.to include(low_fare)
      is_expected.to_not include(high_fare)
    end
  end
end
