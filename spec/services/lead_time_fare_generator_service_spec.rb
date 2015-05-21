require 'rails_helper'

RSpec.describe LeadTimeFareGeneratorService do
  let(:generator)    { described_class.new }

  describe '#initialize' do
    specify do
      expect(generator.query).to eq(LowFareLeadTimeQuery)
    end
  end

  # describe '#lead_times' do
  #   before do
  #     create(:fare, origin: origin, destination: destination, price: price, departure_date: depart)
  #     create(:fare, origin: origin, destination: destination, price: price + 20,
  #                   departure_date: depart)
  #   end

  #   let(:price)  { 200 }
  #   let(:depart) { Time.zone.yesterday }

  #   specify do
  #     expect { report.lead_times }.to change { LeadTimeFare.count }.by 1
  #   end

  #   context 'creating LeadTimeFares' do
  #     subject(:lead_times) { report.lead_times }

  #     specify do
  #       expect(LeadTimeFare.find_by(origin: origin, destination: destination, price: price))
  #       .to be_present
  #     end
  #   end
  # end
end
