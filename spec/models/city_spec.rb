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

RSpec.describe City do
  before { create(:city) }

  describe 'validations' do
    subject { described_class.new }
    specify do
      is_expected.to validate_presence_of :name
      is_expected.to validate_presence_of :airport_code

      is_expected.to validate_uniqueness_of :name
      is_expected.to validate_uniqueness_of :airport_code

      is_expected.to validate_inclusion_of(:region).in_array(%w(Domestic International))
    end
  end

  describe '#favorites' do
    let(:favorite) { create(:favorite_city) }
    subject        { described_class.favorites }
    specify        { is_expected.to include(favorite) }
  end

  describe '#domestic' do
    let(:domestic) { create :domestic_city }
    subject        { described_class.domestic }
    specify        { is_expected.to include(domestic) }
  end

  describe '#international' do
    let(:international) { create :international_city }
    subject             { described_class.international }
    specify             { is_expected.to include international }
  end
end
