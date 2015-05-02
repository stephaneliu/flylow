# == Schema Information
#
# Table name: low_fares
#
#  id              :integer          not null, primary key
#  origin_id       :integer
#  destination_id  :integer
#  price           :decimal(8, 2)    default(0.0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  url             :string(255)
#  departure_dates :text
#  departure_price :decimal(8, 2)    default(0.0)
#  return_dates    :text
#  return_price    :decimal(8, 2)    default(0.0)
#  url             :text
#  last_checked    :datetime
#

require 'rails_helper'

RSpec.describe LowFare do
  describe '#valid' do
    subject { described_class.new }

    specify do
      is_expected.to belong_to :destination
      is_expected.to belong_to :origin

      is_expected.to validate_presence_of :origin
      is_expected.to validate_presence_of :destination
      is_expected.to validate_presence_of :departure_price
      is_expected.to validate_presence_of :return_price

      is_expected.to serialize :departure_dates
      is_expected.to serialize :return_dates
    end
  end

  describe '#departure_dates' do
    before          { low_fare.departure_dates = [today, yesterday] }

    let(:low_fare)  { described_class.new }
    let(:today)     { Time.zone.now }
    let(:yesterday) { 1.day.ago }

    it 'formats date' do
      expect(low_fare.departure_dates).to include(today)
      expect(low_fare.departure_dates).to include(yesterday)
    end
  end

  describe '#return_dates' do
    before          { low_fare.return_dates = [today, yesterday] }

    let(:low_fare)  { described_class.new }
    let(:today)     { Time.zone.now }
    let(:yesterday) { 1.day.ago }

    it 'formats date' do
      expect(low_fare.return_dates).to include(today)
      expect(low_fare.return_dates).to include(yesterday)
    end
  end

  describe '#total_price' do
    let(:departure_price) { 100 }
    let(:return_price)    { 200 }

    subject(:low_fare) do
      described_class.new(departure_price: departure_price, return_price: return_price)
    end

    specify            { expect(low_fare.total_price).to eq(departure_price + return_price) }
  end

  describe '#formatted_return_dates' do
    context 'when return_dates' do
      let(:low_fare) { described_class.new(return_dates: return_dates) }

      context 'is present' do
        let(:return_dates) { [today, tomorrow] }
        let(:today)        { Time.zone.today.to_date }
        let(:tomorrow)     { 1.day.from_now.to_date }
        subject            { low_fare.formatted_return_dates }

        specify do
          is_expected.to eq("#{today.strftime('%-m/%d')}, #{tomorrow.strftime('%-m/%d')}")
        end
      end

      context 'is nil' do
        let(:return_dates) { nil }
        subject            { low_fare.formatted_return_dates }

        specify { is_expected.to be_nil }
      end
    end
  end

  describe '#formatted_departure_dates' do
    context 'when departure_dates' do
      let(:low_fare) { described_class.new(departure_dates: departure_dates) }

      context 'is present' do
        let(:departure_dates) { [today, tomorrow] }
        let(:today)           { Time.zone.now.to_date }
        let(:tomorrow)        { 1.day.from_now.to_date }
        subject { low_fare.formatted_departure_dates }

        specify do
          is_expected.to eq("#{today.strftime('%-m/%d')}, #{tomorrow.strftime('%-m/%d')}")
        end
      end

      context 'is nil' do
        let(:departure_dates) { nil }
        subject               { low_fare.formatted_departure_dates }

        specify { is_expected.to be_nil }
      end
    end
  end
end
