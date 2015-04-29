require 'rails_helper'

describe LowFareStatistic do
  let(:origin)      { create :city }
  let(:destination) { create :city }

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
        expect(low_fare_statistic.low_outbound_price).to eq(0)
        expect(low_fare_statistic.low_return_price).to eq(0)
        expect(low_fare_statistic.checked_on.class).to eq(DateUnknown)
        expect(low_fare_statistic.departure_dates.size).to eq(1)
        expect(low_fare_statistic.departure_dates.first.class).to eq(DateUnknown)
      end

      specify do
        expect(low_fare_statistic.return_dates.size).to eq(1)
        expect(low_fare_statistic.return_dates.first.class).to eq(DateUnknown)
      end
    end
  end

  describe '.create_low_fare' do
    context 'cached data attributes' do
      before do
        create(:fare, origin: origin, destination: destination,
               price: price, departure_date: departure_date, updated_at: checked_on)
        create(:fare, origin: destination, destination: origin,
               price: price, departure_date: return_date, updated_at: checked_on)
      end

      let(:price)          { 200.0 }
      let(:departure_date) { 1.day.from_now.to_date }
      let(:return_date)    { 5.days.from_now.to_date }
      let(:checked_on)     { Time.now }
      subject(:low_fare)   { described_class.new(origin, destination).create_low_fare }

      it 'saves additional \'cached\' data' do
        expect(low_fare.departure_dates).to include(departure_date)
        expect(low_fare.departure_price).to eq (price)
        expect(low_fare.return_price).to eq(price)
        expect(low_fare.return_dates).to include(return_date)
        expect(low_fare.url_reference).to start_with("https://fly.hawaiianairlines.com")
        expect(low_fare.last_checked).to eq(checked_on)
      end
    end
  end

  describe 'total_price' do
    subject(:fare_stat) { described_class.new(build(:city), build(:city)) }
    specify             { expect(fare_stat.total_price).to eq(0) }
  end
end
