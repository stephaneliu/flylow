require 'rails_helper'

RSpec.describe FareFetcherService do
  let(:hnl)        { create :oahu }
  let(:pdx)        { create :city, airport_code: 'PDX' }
  let(:connection) { double('connection') }
  let(:parser)     { double('parser') }
  let(:routes)     { [[hnl, pdx], [pdx, hnl]] }

  # describe '.initialize' do
  #   subject { described_class.new(connection, parser, routes) }
  #   it      { expect { subject }.to_not raise_error }
  # end

  # describe 'attributes' do
  #   subject { described_class.new(connection, parser, routes) }

  #   it do
  #     expect(subject.parser).to eq(parser)
  #     expect(subject.connection).to eq(connection)
  #     expect(subject.routes).to_not be_nil
  #   end
  # end

  describe '.fares', :vcr do
    before do
      allow(parser).to receive(:departure_date=)
      allow(parser).to receive(:parse)
      allow(parser).to receive(:fares).with(:departure) { [[departure_date, fare]] }
      allow(parser).to receive(:fares).with(!:departure) { [] }
      allow(connection).to receive(:get_content).with(any_args)
    end

    let(:departure_date) { 1.day.from_now.to_date }
    let(:fare)           { 100.to_f }

    subject { described_class.new(connection, parser, routes, [1.day.from_now]).fares }

    it 'create lowfare record' do
      expect { subject }.to change { LowFare.count }
      expect(subject.first.class).to eq(Fare)
      expect(subject.first.price).to eq(fare)
      expect(subject.first.departure_date).to eq(departure_date)
    end
  end
end
