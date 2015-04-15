require 'rails_helper'

RSpec.describe FareFetcherService do
  before           { create :oahu }
  let(:logger)     { Logger.new(STDOUT) }
  let(:connection) { double('connection') }

  describe '.initialize' do
    subject { described_class.new(connection, logger) }
    it      { expect { subject }.to_not raise_error }
  end

  describe 'attributes' do
    subject { described_class.new(connection, logger) }

    it do
      expect(subject.logger).to_not be_nil
      expect(subject.connection).to eq(connection)
      expect(subject.cities).to_not be_nil
      expect(subject.oahu).to_not be_nil
    end
  end

  describe '.fares', :vcr do
    before do
      create(:oahu)
      create(:favorite_city, airport_code: 'PDX')
    end

    let(:connection) { FareConnectionService.new }
    subject { described_class.new(connection, logger, [1.day.from_now]).fares }

    it 'create lowfare record' do
      expect { subject }.to change { LowFare.count }
    end
  end
end
