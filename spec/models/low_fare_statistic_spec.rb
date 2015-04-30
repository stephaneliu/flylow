require 'rails_helper'

describe LowFareStatistic do
  let(:origin)      { create :city, airport_code: 'HNL' }
  let(:destination) { create :city, airport_code: 'PDX' }

  describe '#initialize' do
    subject { described_class.new(origin, destination) }

    specify do
      expect(subject.updated_since).to_not be_nil
    end
  end
  describe 'in general' do
    context 'cities without fares' do
      subject(:low_fare_statistic) { described_class.new(origin, destination) }

      specify do

      end
    end
  end

  describe '.create_low_fare' do
    context 'cached data attributes' do
      before do
        create(:fare, origin: origin, destination: destination,
                      price: departure_price, departure_date: departure_date,
                      updated_at: checked_on)
        create(:fare, origin: destination, destination: origin,
                      price: return_price, departure_date: return_date,
                      updated_at: checked_on)
        create(:fare, origin: destination, destination: origin,
                      price: return_price, departure_date: departure_date)
      end

      let(:departure_price) { 200.0 }
      let(:return_price)    { 300.0 }
      let(:departure_date)  { 1.day.from_now.to_date }
      let(:return_date)     { 5.days.from_now.to_date }
      let(:checked_on)      { Time.now }
      subject(:low_fare)    { described_class.new(origin, destination).create_low_fare }

      it 'saves additional \'cached\' data' do
        expect(low_fare.departure_dates).to include(departure_date)
        expect(low_fare.departure_price).to eq(departure_price)
        expect(low_fare.return_price).to eq(return_price)
        expect(low_fare.return_dates).to include(return_date)
        expect(low_fare.url_reference).to start_with('https://fly.hawaiianairlines.com')
        expect(low_fare.last_checked).to be_within(1.second).of checked_on
      end

      it 'has return dates after departure dates' do
        expect(low_fare.return_dates).to_not include(departure_date)
      end
    end
  end

  describe 'total_price' do
    subject(:fare_stat) { described_class.new(build(:city), build(:city)) }
    specify             { expect(fare_stat.total_price).to eq(0) }
  end
end
