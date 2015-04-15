require 'rails_helper'

RSpec.describe FareFetcherService do
  let(:hnl)        { create :oahu }
  let(:pdx)        { create :city, airport_code: 'PDX' }
  let(:logger)     { Logger.new(STDOUT) }
  let(:connection) { double('connection') }
  let(:parser)     { double('parser') }
  let(:routes)     { [[hnl, pdx], [pdx, hnl]] }

  describe '.initialize' do
    subject { described_class.new(connection, parser, logger) }
    it      { expect { subject }.to_not raise_error }
  end

  describe 'attributes' do
    subject { described_class.new(connection, parser, logger) }

    it do
      expect(subject.logger).to_not be_nil
      expect(subject.parser).to eq(parser)
      expect(subject.connection).to eq(connection)
      expect(subject.routes).to_not be_nil
    end
  end

  describe '.fares', :vcr do
    let(:connection) { DomesticFareConnectionService.new }

    subject do
      described_class.new(connection, parser, routes, logger,
                          [1.day.from_now]).fares
    end

    it 'create lowfare record' do
      expect(subject.first.class).to eq(Fare)
      expect { subject }.to change { LowFare.count }
    end
  end
end
