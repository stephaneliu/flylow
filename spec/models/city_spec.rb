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

require 'rails_helper'

describe City do
  before { create(:city) }

  describe '#favorites' do
    let(:favorite) { create(:favorite_city) }
    subject        { City.favorites }
    it             { is_expected.to include(favorite) }
  end

  describe '#domestic' do
    let(:domestic) { create :domestic_city }
    subject        { City.domestic }
    it             { is_expected.to include(domestic) }
  end

  describe '#international' do
    let(:international) { create :international_city }
    subject             { City.international }
    it                  { is_expected.to include international }
  end
end
