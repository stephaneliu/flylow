require 'spec_helper'

describe FareStatistic do

  describe '#return_dates' do
    context 'when initialized as nil' do
      before  { @fare_stat = build(:fare_statistic, return_dates: nil) }
      subject { @fare_stat.return_dates }
      it      { should == nil }
    end

    context 'when assigned' do
      before  { @fare_stat = build(:fare_statistic, return_dates: [Time.now.to_date]) }
      subject { @fare_stat.return_dates }
      it      { should_not be_empty }
    end
  end

  describe '#low_upcoming_fares_for' do
    before do
      @depart_city = create :city
      @return_city = create :city
      @cities      = [@depart_city, @return_city]
    end

    context 'when there are no fares' do
      subject { FareStatistic.low_upcoming_fares_for(@cities) }
      specify { subject.should be_kind_of(Array) }
    end
    
    context 'return collection' do
      subject { FareStatistic.low_upcoming_fares_for(@cities) }
      it      { should be_a Array }

      context 'departure_dates sort order' do
        before do
          low_fare        = 200
          depart_latest   = create(:fare, departure_date: 7.days.from_now.to_date,
                                   origin: @depart_city, destination: @return_city, price: low_fare)
          depart_earliest = create(:fare, departure_date: 2.days.from_now.to_date,
                                   origin: @depart_city, destination: @return_city, price: low_fare)
          depart_later    = create(:fare, departure_date: 5.days.from_now.to_date,
                                   origin: @depart_city, destination: @return_city, price: low_fare)
          @fares          = [depart_earliest.departure_date, depart_later.departure_date,
                             depart_latest.departure_date]
        end

        subject { FareStatistic.low_upcoming_fares_for(@cities).first.departure_dates }
        it      { should == @fares }
      end

    end

    context 'return collection element' do
      before do
        @origin       = create :fare, origin: @cities.first, destination: @cities.last
        @destination  = create :fare, origin: @cities.last, destination: @cities.first
      end

      subject { FareStatistic.low_upcoming_fares_for(@cities).first }
      it      { should be_a FareStatistic }
    end

    context 'when no return fares' do
      before  { @origin = create :fare, origin: @cities.first, destination: @cities.last }
      subject { FareStatistic.low_upcoming_fares_for(@cities) }
      specify { subject.map(&:low_return_price).map(&:to_s).should == ["0"] }
    end

    context 'since_last_updated_at parameter' do
      context 'with default value' do
        context "lowest fares" do
          before do
            departure_date      = 2.week.from_now.to_date
            @current_low_price  = 400.0

            Timecop.freeze(2.hours.ago) do
              create_mirror_flights(200, @cities.first, @cities.last, departure_date)
            end
            Timecop.freeze(55.minutes.ago) do
              create_mirror_flights(@current_low_price, @cities.first, @cities.last, departure_date)
            end
          end

          subject { FareStatistic.low_upcoming_fares_for(@cities) }
          specify { subject.size.should == 1}
          specify { subject.first.low_outbound_price.to_s.should == @current_low_price.to_s }
          specify { subject.first.low_return_price.to_s.should == @current_low_price.to_s }
        end

        def create_mirror_flights(price, origin, destination, departure_date)
          create(:fare, price: price, origin: origin,
                 destination: destination, departure_date: departure_date)
          create(:fare, price: price, origin: destination,
                 destination: origin, departure_date: departure_date)
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
            @lowest_fare = create(:fare, price: 400, origin: @depart_city,
                                  destination: @return_city, departure_date: departure)
          end
        end
        subject { FareStatistic.low_upcoming_fares_for(@cities, 1.day.ago) }
        specify { subject.first.low_outbound_price.to_s.should == @lowest_fare.price.to_s }
      end
    end
  end

end
