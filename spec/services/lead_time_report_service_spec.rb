require 'rails_helper'

RSpec.describe LeadTimeReportService do
  let(:report)       { described_class.new(routes: [origin, destination]) }
  let!(:origin)      { create :oahu }
  let!(:destination) { create :city }
  let(:routes)       { [hnl, destination] }

  describe '#initialize' do
    specify do
      expect(report.query).to eq(LowFareLeadTimeQuery)
      expect(report.routes).to eq([origin, destination])
      expect(report.departure_dates).to eq([Time.zone.yesterday])
    end
  end
end
