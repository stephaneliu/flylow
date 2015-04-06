require 'rails_helper'

describe Scrap do
  let(:connection) do
    double('fare_connection_service',
           origin:    'HNL', destination:  'PDX',
           travelers: '4', departure_date: 1.day.from_now.localtime)
  end

  describe '.initialize' do
    subject { described_class.new(connection) }

    it do
      expect(subject.origin).to eq(connection.origin)
      expect(subject.destination).to eq(connection.destination)
      expect(subject.travelers).to eq(connection.travelers)
      expect(subject.departure_date).to eq(connection.departure_date)
    end
  end

  describe '.get_days_with_fare' do
    before do
      allow(connection).to receive(:get_content).with(true).and_return('')
    end

    let(:parser) { described_class.new(connection) }
    subject      { parser.get_days_with_fare }

    it 'returns parsed fares' do
    end
  end
end
