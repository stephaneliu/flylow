# == Schema Information
#
# Table name: low_fares
#
#  id              :integer          not null, primary key
#  origin_id       :integer
#  destination_id  :integer
#  price           :decimal(8, 2)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  departure_dates :text
#  departure_price :decimal(8, 2)
#  return_dates    :text
#  return_price    :decimal(8, 2)
#  url_reference   :string(255)
#  last_checked    :string(255)
#

require 'rails_helper'

describe LowFare do
  describe '#valid' do
    subject { described_class.new }

    specify do
      is_expected.to belong_to :destination
      is_expected.to belong_to :origin
      is_expected.to validate_presence_of :origin
      is_expected.to validate_presence_of :destination
      is_expected.to validate_presence_of :price
    end
  end
end
