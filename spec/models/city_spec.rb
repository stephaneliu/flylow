# == Schema Information
# Schema version: 20130302222428
#
# Table name: cities
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  region       :string(255)
#  airport_code :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  favorite     :boolean
#

require 'spec_helper'

describe City do
  before { create(:city) }

  describe '#favorites' do
    before  { @favorite = create(:favorite_city) }
    subject { City.favorites }
    specify { subject.size.should == 1 }
    it      { should include @favorite  }
  end

  describe '#domestic' do
    before  { @domestic = create :domestic_city }
    subject { City.domestic }
    specify { subject.size.should == 2}
    it      { should include @domestic }
  end

  describe '#international' do
    before  { @intl = create :international_city }
    subject { City.international }
    specify { subject.size.should == 1}
    it      { should include @intl }
  end
end
