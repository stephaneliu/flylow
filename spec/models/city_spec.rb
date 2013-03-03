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

  describe '#favorites' do
    before do
      create(:city)
      create(:favorite_city)
    end

    subject { City.favorites.count }
    it      { should be 1 }
  end
end
