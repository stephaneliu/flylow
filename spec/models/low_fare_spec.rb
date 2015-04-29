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
#  url_reference   :string(255)
#  departure_dates :text
#  departure_price :decimal(8, 2)
#  return_dates    :text
#  return_price    :decimal(8, 2)
#  url             :text
#  last_checked    :datetime
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

      is_expected.to serialize :departure_dates
      is_expected.to serialize :return_dates
    end
  end

  describe '#departure_dates' do
    before          { low_fare.departure_dates = [today, yesterday] }

    let(:low_fare)  { described_class.new }
    let(:today)     { Time.now }
    let(:yesterday) { 1.day.ago }

    it 'formats date' do
      expect(low_fare.departure_dates).to include(today)
      expect(low_fare.departure_dates).to include(yesterday)
    end
  end

  describe '#return_dates' do
    before          { low_fare.return_dates = [today, yesterday] }

    let(:low_fare)  { described_class.new }
    let(:today)     { Time.now }
    let(:yesterday) { 1.day.ago }

    it 'formats date' do
      expect(low_fare.return_dates).to include(today)
      expect(low_fare.return_dates).to include(yesterday)
    end
  end
end
