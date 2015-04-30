require 'rails_helper'

RSpec.describe RouteBuilderService do
  let!(:hnl) { create(:oahu) }
  let(:pdx)  { create(:city, name: 'Portland', airport_code: 'PDX') }
  let(:sfo)  { create(:city, name: 'San Francisco', airport_code: 'SFO') }
  let(:lax)  { create(:city, name: 'Los Angeles', airport_code: 'LAX') }

  let(:route_builder) { described_class.new(destinations) }

  describe 'initialize' do
    let(:destinations)  { [pdx, sfo, lax] }

    it do
      expect(route_builder.destinations).to include(pdx)
      expect(route_builder.home).to eq(hnl)
    end
  end

  describe '.generate' do
    context 'when destinations is an array with PDX, SFO, LAX' do
      let(:destinations) { [pdx, sfo, lax] }
      subject            { route_builder.generate }

      it do
        is_expected.to include [pdx, hnl]
        is_expected.to include [hnl, pdx]
        is_expected.to include [sfo, hnl]
        is_expected.to include [hnl, sfo]
        is_expected.to include [lax, hnl]
        is_expected.to include [hnl, lax]
      end
    end

    context 'when destinations include HNL' do
      let(:destinations) { [pdx, sfo, lax, hnl] }
      subject            { route_builder.generate }
      specify            { is_expected.to_not include [hnl, hnl] }
    end
  end
end
