require 'spec_helper'

describe FareStatistic do

  describe '#return_dates' do
    context 'when initialized as nil' do
      before  { @fare_stat = build(:fare_statistic, return_dates: nil) }
      subject { @fare_stat.return_dates }
      it      { should == [] }
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
      it      { should be_empty }
    end
    
    context 'return collection' do
      subject { FareStatistic.low_upcoming_fares_for(@cities) }
      it      { should be_a Array }
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
      subject { FareStatistic.low_upcoming_fares_for(@cities).map(&:low_return_price) }
      it      { should == [0] }
    end

    context 'since_last_updated_at parameter' do
      context 'with default value' do
        before do
          departure = 1.week.from_now.to_date
          Timecop.freeze(2.hours.ago) do
            create(:fare, price: 200, origin: @depart_city, destination: @return_city,
                   departure_date: departure)
            create(:fare, price: 200, origin: @return_city, destination: @depart_city,
                   departure_date: departure)
          end
          Timecop.freeze(35.minutes.ago) do
            @lowest_fare = 400.0
            # need mirror flight since algorithm doesn't care who is origin or destination
            create(:fare, price: 400, origin: @depart_city, destination: @return_city, departure_date: departure)
            create(:fare, price: 400, origin: @return_city, destination: @depart_city, departure_date: departure)
          end
        end

        context "lowest outbound fare" do
          subject { FareStatistic.low_upcoming_fares_for(@cities) }
          specify { subject.first.low_outbound_price.to_s.should == @lowest_fare.to_s }
        end

        context "lowest return fare" do
          before do
            departure = 2.week.from_now.to_date
            Timecop.freeze(2.hours.ago) do
              create :fare, price: 200, origin: @cities.last, destination: @cities.first, departure_date: departure
            end
            Timecop.freeze(55.minutes.ago) do
              @lowest_return_fare = create :fare, price: 400, origin: @cities.last, destination: @cities.first, departure_date: departure
            end
          end

          subject { FareStatistic.low_upcoming_fares_for(@cities) }
          specify { subject.size.should == 1}
          specify { subject.first.low_return_price.to_s.should == @lowest_return_fare.price.to_s }
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

  describe "#merge" do
    before do
      @fare_stat      = build :fare_statistic
      @nil_fare_stat  = FareStatistic.new({})
    end

    it "Attributes with values should overwrite nil attributes" do
      merged_stat = @fare_stat.merge(@nil_fare_stat)
      merged_stat.instance_variables.each do |attribute| 
        @fare_stat.instance_variable_get(attribute.to_sym).should == merged_stat.instance_variable_get(attribute.to_sym)
      end
    end

    context "when object's attributes being merged has value" do
      it "should behave like a hash merge" do
        {1 => 2, 2 => 3}.merge({1 => 5}).should == {1 => 5, 2 => 3}
      end

      it "should merge with object passed in value" do
        origin        = "I am the new origin"
        assumed_stat  = FareStatistic.new(origin: origin)

        @fare_stat.merge(assumed_stat).origin.should == origin
      end
    end

  end

end
