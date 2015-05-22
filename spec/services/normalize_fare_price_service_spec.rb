require 'rails_helper'

RSpec.describe NormalizeFarePriceService do
  let(:normalizer) { described_class.new(fares: fares) }
  let(:fares)      { [] }

  describe '#initialize' do
    specify { expect(normalizer.fares).to eq(fares) }
  end

  describe '#normalize' do
    let(:fare) do
      create(:fare, created_at: created_at,  updated_at: updated_at, price: price,
                    origin: origin, destination: destination, departure_date: departure_date)
    end
    let(:created_at)     { 23.hours.ago }
    let(:updated_at)     { 23.hours.ago }
    let!(:price)         { 200 }
    let(:origin)         { create :city }
    let(:destination)    { create :city }
    let(:departure_date) { 1.day.from_now }
    let(:fares)          { [fare] }

    specify { expect(normalizer.prices).to eq([price]) }

    context 'when created_at and updated_at span 2 days' do
      let(:created_at) { 5.days.ago }
      let(:updated_at) { 3.days.ago }

      specify { expect(normalizer.prices.map(&:to_i)).to eq([price, price, price]) }
    end

    context 'when created_at and updated_at span 5 days' do
      let(:created_at) { 7.days.ago }
      let(:updated_at) { 3.days.ago }

      specify { expect(normalizer.prices.map(&:to_i)).to eq([price, price, price, price, price]) }
    end
  end
end
