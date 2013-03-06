require 'spec_helper'

describe FareStatistic do
  describe '#low_fares_for' do
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
  end
end
