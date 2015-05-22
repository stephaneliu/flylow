require 'rails_helper'

RSpec.describe AveragePriceCalculatorService do
  let(:query) do
    described_class.new(origin: origin, destination: destination, departure_date: departure_date)
  end

  let(:origin)         { create :city }
  let(:destination)    { create :city }
  let(:departure_date) { Time.zone.now.to_date }

  describe '#initialize' do
    specify do
      expect(query.origin).to eq(origin)
      expect(query.destination).to eq(destination)
      expect(query.departure_date).to eq(departure_date)
    end
  end

  describe '#calculate' do
    let!(:high_fare) do
      create(:fare, origin: origin, destination: destination, departure_date: departure_date,
                    price: high_price)
    end
    let!(:low_fare) do
      create(:fare, origin: origin, destination: destination, departure_date: departure_date,
                    price: low_price)
    end

    let(:high_price) { low_price + 100 }
    let(:low_price)  { 200 }

    it 'returns fares with low prices' do
      average = DescriptiveStatistics::Stats.new([high_price, low_price]).mean
      expect(query.calculate).to eq(average)
    end

    context 'with fares created 12 months ago' do
      before do
        create(:fare, created_at: 12.months.ago, price: 10_000,
                      origin: origin, destination: destination, departure_date: departure_date)
      end

      it 'in not included in calculation' do
        average = DescriptiveStatistics::Stats.new([high_price, low_price]).mean
        expect(query.calculate).to eq(average)
      end
    end

    context 'fares with created_at and updated_at on different days' do
      before do
        create(:fare, created_at: 2.days.ago, updated_at: 1.day.ago, price: multi_day_fare,
                      origin: origin, destination: destination, departure_date: departure_date)
      end

      let(:multi_day_fare) { 1_000 }

      it 'adds an data point for each day fare is observed' do
        average = DescriptiveStatistics::Stats.new([high_price, low_price, multi_day_fare,
                                                    multi_day_fare]).mean
        expect(query.calculate).to eq(average)
      end
    end
  end
end
