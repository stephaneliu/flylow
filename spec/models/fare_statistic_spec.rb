require 'spec_helper'

describe FareStatistic do
  describe '#low_upcoming_fares_for' do
    before { @cities = create_list(:city, 2) }

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
            create :fare, price: 200, origin: @cities.first, destination: @cities.last, departure_date: departure
          end
          Timecop.freeze(55.minutes.ago) do
            @lowest_fare = create :fare, price: 400, origin: @cities.first, destination: @cities.last, departure_date: departure
          end
        end

        context "lowest outbound fare" do
          subject { FareStatistic.low_upcoming_fares_for(@cities) }
          specify { subject.size.should == 1}
          specify { subject.first.low_outbound_price.to_s.should == @lowest_fare.price.to_s }
        end

        context "lowest return fare" do
          before do
            departure = 2.week.from_now.to_date
            Timecop.freeze(2.hours.ago) do
              create :fare, price: 200, origin: @cities.last, destination: @cities.first, departure_date: departure
            end
            Timecop.freeze(55.minutes.ago) do
              @lowest_fare = create :fare, price: 400, origin: @cities.last, destination: @cities.first, departure_date: departure
            end
          end

          subject { FareStatistic.low_upcoming_fares_for(@cities) }
          specify { subject.size.should == 1}
          specify { subject.first.low_return_price.to_s.should == @lowest_fare.price.to_s }
        end
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
      pending
    end

  end

end
