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
    before { @existing = create :fare }

    context "when price has changed" do
      before do
        @existing_updated_at = @existing.updated_at
        @fare           = build(:fare, price: (@existing.price + 100), origin: @existing.origin,
                                 destination: @existing.destination)
        @fare.smart_save
        @existing.reload
      end

      subject { @existing_updated_at }
      it      { should == @existing.updated_at}

    end

    context "when price has not change" do
      before do
        @existing_updated_at = @existing.updated_at
        @fare           = build(:fare, price: (@existing.price), origin: @existing.origin,
                                 destination: @existing.destination)
        @fare.smart_save
        @existing.reload
      end

      subject { @existing_updated_at }
      it      { should_not == @existing.updated_at}
    end
  end

end
