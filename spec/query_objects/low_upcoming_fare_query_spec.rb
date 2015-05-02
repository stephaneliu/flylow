require 'rails_helper'

RSpec.describe LowUpcomingFareQuery do
  let(:origin)      { create(:city) }
  let(:destination) { create(:city) }
  let(:query)       { described_class.new(origin, destination) }

  describe '#initialize' do
    specify           { expect(query.low_upcoming_fares).to_not be_nil }

    context 'when departure is false' do
      it 'assigns origin to departure and departure to origin' do
        expect(Fare).to receive(:where).with(origin_id: destination, destination_id: origin)
        described_class.new(origin, destination, !:departure)
      end
    end
  end

  describe '#find_all' do
    subject { query.find_all(Time.zone.now, 2.days.from_now) }
    specify { is_expected.to be_a ActiveRecord::Relation }
  end
end
