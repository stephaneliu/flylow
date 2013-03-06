# == Schema Information
# Schema version: 20130302222428
#
# Table name: fares
#
#  id             :integer          not null, primary key
#  price          :decimal(8, 2)
#  departure_date :date
#  origin_id      :integer
#  destination_id :integer
#  comments       :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Fare do

  describe '.smart_save' do
    before do
      @price      = "100.00"
      @existing   = create :fare 
      @not_first  = create :fare, origin: @existing.origin, destination: @existing.destination, price: @price
    end

    context "when price has changed" do
      before do
        @not_first_updated_at = @not_first.updated_at
        @fare = build(:fare, price: @existing.price, origin: @existing.origin, destination: @existing.destination)

        @fare.smart_save
        @not_first.reload
      end

      subject { @not_first_updated_at.to_s }
      it      { should == @not_first.updated_at.to_s}


    end

    context "when price has not change" do
      before do
        @not_first_updated_at  = @not_first.updated_at
        @fare                 = build(:fare, price: @price, origin: @existing.origin,
                                      destination: @existing.destination)
        @fare.smart_save
        @not_first.reload
      end

      subject { @not_first_updated_at }
      it      { should_not == @not_first.updated_at }
    end
  end

end
