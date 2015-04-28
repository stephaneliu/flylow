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
      subject(:low_fare_statistic) { LowFareStatistic.new(origin, destination) }

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

  describe ".create_low_fare_for" do
    let(:low_fare_statistic) { LowFareStatistic.new(origin, destination) }

    it "should create a LowFare object" do
      double('LowFare',
             find_or_initialize_by_origin_id_and_destination_id: true,
             price: true, save!: true) 
      expect { low_fare_statistic.create_low_fare }.to change { LowFare.count }.by(1)
    end
  end

  describe "total_price" do
    before do
      @outbound_price = 200
      @return_price   = 300
      @fare_stat      = LowFareStatistic.new(build(:city), build(:city))
    end

    subject { @fare_stat.total_price }
    it      { should == 0 }
  end
end
