require 'spec_helper'

describe LowFareStatistic do

  describe 'in general' do
    before do
      @origin       = create :city
      @destination  = create :city
    end
    context 'cities without fares' do
      subject { LowFareStatistic.new(@origin, @destination) }
      its(:low_outbound_price)  { should == 0 }
      its(:low_return_price)    { should == 0 }
      specify { subject.checked_on.class.should == DateUnknown }

      specify do
        subject.departure_dates.size.should == 1 
        subject.departure_dates.first.class.should == DateUnknown
      end

      specify do
        subject.return_dates.size.should == 1
        subject.return_dates.first.class.should == DateUnknown
      end
    end
  end

  describe ".create_low_fare_for" do
    before do
      @origin              = create(:city)
      @destination         = create(:city)
      @low_fare_statistic = LowFareStatistic.new(@origin, @destination)
    end

    it "should create a LowFare object" do
      round_trip_price = 200.0

      mock(LowFare, find_or_initialize_by_origin_id_and_destination_id: true,
           :price => true, :save! => true) 

      @low_fare_statistic.create_low_fare
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
