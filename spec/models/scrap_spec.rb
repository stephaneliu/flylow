require 'spec_helper'

describe Scrap do
  describe ".initialize" do
    context "defaults" do
      subject { Scrap.new }
      specify { subject.travelers.should == 2 }
      specify { subject.round_trip.should == true }
    end
  end
end
