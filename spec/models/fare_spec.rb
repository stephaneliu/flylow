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

require 'rails_helper'

describe Fare do
  describe 'validations' do
    subject { described_class.new }

    specify do
      is_expected.to validate_presence_of :price
      is_expected.to validate_presence_of :origin_id
      is_expected.to validate_presence_of :destination_id
    end
  end

  describe '#smart_save' do
    let!(:existing_fare) { create :fare }
    let(:fare) do
      build(:fare, price: new_price,
                   origin: existing_fare.origin,
                   destination: existing_fare.destination)
    end

    context 'when price has changed' do
      let(:new_price) { existing_fare.price + 100 }

      specify do
        expect { fare.smart_save }.to change { described_class.count }.by 1
        expect { fare.smart_save }.to_not change { existing_fare.updated_at }
      end
    end

    context 'when price has not change' do
      let(:new_price) { existing_fare.price }

      specify do
        # This syntax not detecting change of updated_at
        # expect { fare.smart_save }.to change { existing_fare.updated_at }

        current_updated_at = existing_fare.updated_at
        fare.smart_save
        existing_fare.reload
        expect(existing_fare.updated_at).to_not eq(current_updated_at)
        expect { fare.smart_save }.to_not change { described_class.count }
      end
    end
  end
end
