require 'spec_helper'

describe Scrap do
  describe ".initialize" do
    context "defaults" do
      subject { Scrap.new("HNL", "PDX") }
      specify { subject.travelers.should == 2 }
    end
  end
end
