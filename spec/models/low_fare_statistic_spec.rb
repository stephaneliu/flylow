require 'spec_helper'

describe LowFareStatistic do

  describe '#return_dates' do
    context 'when initialized as nil' do
      before  { @fare_stat = build(:low_fare_statistic, return_dates: nil) }
      subject { @fare_stat.return_dates }
      it      { should == nil }
    end

    context 'when assigned' do
      before  { @fare_stat = build(:low_fare_statistic, return_dates: [Time.now.to_date]) }
      subject { @fare_stat.return_dates }
      it      { should_not be_empty }
    end
  end

  describe ".sort" do
    context "without destinations" do
      before do
        @first  = build(:low_fare_statistic, origin: build(:city, name: "A I am first"))
        @second = build(:low_fare_statistic, origin: build(:city, name: "B I am second"))
        @third  = build(:low_fare_statistic, origin: build(:city, name: "C I am third"))
        @low_fare_statistics = [@second, @third, @first]
      end

      subject { @low_fare_statistics.sort }
      it      { should == [@first, @second, @third] }

      context "when elements does not have origin" do
        before  { @low_fare_statistics << (@fourth = build(:low_fare_statistic, origin: nil)) }
        subject { @low_fareStatistics.sort }
        it      { should = [@first, @second, @third, @fourth] }
      end
    end

    context "when destinations exists" do
      before do
        @first  = build(:low_fare_statistic, origin: build(:city, name: "A"),
                        destination: build(:city, name: "A"))
        @second = build(:low_fare_statistic, origin: build(:city, name: "A"),
                        destination: build(:city, name: "B"))
        @third  = build(:low_fare_statistic, origin: build(:city, name: "A"),
                        destination: build(:city, name: "C"))
        @fare_stats = [@third, @first, @second]
      end

      subject { @fare_stats.sort }
      it      { should == [@first, @second, @third] }
    end
  end

  describe '#low_upcoming_fares_for' do
    before do
      @depart_city = create :city
      @return_city = create :city
      @cities      = [@depart_city, @return_city]
    end

    context 'when there are no fares' do
      subject { LowFareStatistic.low_upcoming_fares_for(@cities) }
      specify { subject.should be_kind_of(Array) }
    end
    
    context 'return collection' do
      subject { LowFareStatistic.low_upcoming_fares_for(@cities) }
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

        subject { LowFareStatistic.low_upcoming_fares_for(@cities).first.departure_dates }
        it      { should == @fares }
      end
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
      specify { subject.map(&:low_return_price).map(&:to_s).should include("0") }
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

          subject { LowFareStatistic.low_upcoming_fares_for(@cities) }
          specify { subject.size.should == 2}
          specify { subject.first.low_outbound_price.to_s.should == @current_low_price.to_s }
          specify { subject.first.low_return_price.to_s.should == @current_low_price.to_s }
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
        specify { subject.first.low_outbound_price.to_s.should == @low_price.to_s }
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
           destination: origin, departure_date: departure_date)
  end

end
