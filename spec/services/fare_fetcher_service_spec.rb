require 'rails_helper'

RSpec.describe FareFetcherService do
  before { create :oahu }
  let(:logger) { Logger.new(STDOUT) }

  describe '.initialize' do
    subject { described_class.new(logger) }
    it      { expect { subject }.to_not raise_error }
  end

  describe 'attributes' do
    subject { described_class.new(logger) }
    it      { expect(subject.logger).to_not be_nil }
  end

  describe '.get_fares', :vcr do
    before do
      create(:oahu)
      create(:favorite_city)
    end

    subject { described_class.new(logger).get_fares }
    it      { expect { subject }.to change { LowFare.count }.by 1 }
  end
end
