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
    let(:destinations) { [pdx, sfo, lax] }

    context 'when destinations is an array with PDX, SFO, LAX' do
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

    context 'when only_one_way is true' do
      subject(:routes) { route_builder.generate(only_one_way=true) }

      specify do
        expect(routes).to_not include [pdx, hnl]
        expect(routes).to_not include [sfo, hnl]
        expect(routes).to_not include [lax, hnl]
      end
    end
  end
end
