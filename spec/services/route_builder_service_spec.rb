require 'rails_helper'

RSpec.describe RouteBuilderService do
  let!(:hnl) { create(:oahu) }
  let(:pdx)  { create(:city, name: 'Portland', airport_code: 'PDX') }
  let(:sfo)  { create(:city, name: 'San Francisco', airport_code: 'SFO') }
  let(:lax)  { create(:city, name: 'Los Angeles', airport_code: 'LAX') }

  let(:route_builder) { described_class.new(destinations) }

  describe 'initialize', :focus do
    let(:destinations)  { [pdx, sfo, lax] }

    it do
      puts "hnl count: #{City.count(airport_code: 'HNL')}"
      expect(route_builder.destinations).to include(pdx)
      expect(route_builder.home).to eq(hnl)
    end
  end

  describe '#generate' do
    let(:destinations)  { %w(pdx sfo lax) }

    context 'when destinations is PDX, SFO, LAX' do
      subject { described_class.generate(destinations) }
      it      { is_expected.to include(%w(PDX HNL)) }
    end
  end

  describe '.generate' do
    context 'when destinations is an array with PDX, SFO, LAX' do
      let(:destinations)  { %w(pdx sfo lax) }
      subject { route_builder.generate }

      it do
        is_expected.to include(%w(PDX HNL))
        is_expected.to include(%w(HNL PDX))
        is_expected.to include(%w(SFO HNL))
        is_expected.to include(%w(HNL SFO))
        is_expected.to include(%w(LAX HNL))
        is_expected.to include(%w(HNL LAX))
      end
    end

    context 'when destinations are arguments with PDX, SFO, LAX' do
      subject { described_class.new('pdx', 'sfo', 'lax').generate }

      # TODO: Shared behavior
      it do
        is_expected.to include(%w(PDX HNL))
        is_expected.to include(%w(HNL PDX))
        is_expected.to include(%w(SFO HNL))
        is_expected.to include(%w(HNL SFO))
        is_expected.to include(%w(LAX HNL))
        is_expected.to include(%w(HNL LAX))
      end
    end

    context 'when destinations include HNL' do
      let(:destinations)  { %w(pdx sfo lax hnl) }
      subject { route_builder.generate }

      it do
        is_expected.to_not include(%w(HNL HNL))
      end
    end
  end
end
