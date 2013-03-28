require 'spec_helper'

describe LowFareStatistic do

  describe ".create_low_fare_for" do
    before do
      @origin              = create(:city)
      @destination         = create(:city)
      @low_fare_statistic = LowFareStatistic.new(@origin, @destination)
    end

    it "should create a LowFare object" do
      round_trip_price = 200.0
      @low_fare_statistic.should_receive(:round_trip_price).and_return(round_trip_price)
      low_fare = mock(LowFare, :price= => true, :save => true)
      LowFare.should_receive(:find_or_initialize_by_origin_id_and_destination_id).
        with(origin: @origin, destination: @destination).and_return(low_fare)
      
      @low_fare_statistic.create_low_fare
    end

  end

  describe '.roundtrip_low_fare_statistics' do
    before do
      @origin       = create :city
      @destination  = create :city
    end

    context 'return collection element' do
      before do
        @origin       = create :fare, origin: @cities.first, destination: @cities.last
        @destination  = create :fare, origin: @cities.last, destination: @cities.first
      end

      subject { LowFareStatistic.low_upcoming_fares_for(@cities).first }
      it      { should be_a LowFareStatistic }
    end

    context 'when no return fares' do
      before  { @origin = create :fare, origin: @cities.first, destination: @cities.last }
      subject { LowFareStatistic.low_upcoming_fares_for(@cities) }
      specify { subject.map(&:low_return_price).map(&:to_f).should include(0) }
    end

    context 'updated_since parameter' do
      context 'with default value' do
        context "lowest fares" do
          before do
            departure_date      = 2.week.from_now.to_date
            @current_low_price  = 400.0.to_f

            Timecop.freeze(2.hours.ago) do
              create_mirror_flights(200, @cities.first, @cities.last, departure_date)
            end

            Timecop.freeze(55.minutes.ago) do
              create_mirror_flights(@current_low_price, @cities.first, @cities.last, departure_date)
            end
          end

          subject { LowFareStatistic.low_upcoming_fares_for(@cities) }
          specify { subject.size.should == 2}
          specify { subject.first.low_outbound_price.to_f.should == @current_low_price }
          specify { subject.first.low_return_price.to_f.should == @current_low_price }
        end
      end

      context "when set to 1 day ago" do
        before do
          departure = 1.week.from_now.to_date
          Timecop.freeze(5.days.ago) do
            create(:fare, price: 200, origin: @depart_city, destination: @return_city,
                   departure_date: departure)
          end
          Timecop.freeze(15.hours.ago) do
            @low_price = 400.0
            create_mirror_flights(@low_price, @depart_city, @return_city, departure)
          end
        end
        subject { LowFareStatistic.low_upcoming_fares_for(@cities, 1.day.ago) }
        specify { subject.first.low_outbound_price.to_f.should == @low_price.to_f }
      end
    end

    context "return dates" do
      before do
        # return date should be after departure date
        @valid_return_date    = 4.days.from_now.to_date
        @invalid_return_date  = 2.days.from_now.to_date
        @fare_outbound        = create(:fare, departure_date: 3.day.from_now.to_date,
                                       origin: @cities.first, destination: @cities.last, price: 100)
        @invalid_return       = create(:fare, departure_date: @invalid_return_date,
                                       origin: @cities.last, destination: @cities.first, price: 100)
        @fare_return          = create(:fare, departure_date: @valid_return_date,
                                       origin: @cities.last, destination: @cities.first, price: 100)
      end

      subject do
        LowFareStatistic.low_upcoming_fares_for(@cities).map do |stat|
          stat.return_dates if stat.origin == @cities.first
        end.flatten
      end

      it { should include(@valid_return_date) }
      it { should_not include(@invalid_return_date) }
    end
  end

  describe "total_price" do
    before do
      @outbound_price = 200
      @return_price   = 300
      @fare_stat = build(:low_fare_statistic, low_outbound_price: @outbound_price,
                        low_return_price: @return_price)
    end
    subject { @fare_stat.total_price }
    it      { should == @outbound_price + @return_price }
  end

  def create_mirror_flights(price, origin, destination, departure_date)
    create(:fare, price: price, origin: origin,
           destination: destination, departure_date: departure_date)
    create(:fare, price: price, origin: destination,
           destination: origin, departure_date: departure_date + 1)
  end

end
