require 'rails_helper'

describe Scrap do
  let(:origin)      { 'HNL' }
  let(:destination) { 'PDX' }
  let(:connection)  { FareConnectionService.new(origin, destination) }

  describe '.initialize' do
    subject { described_class.new(connection) }

    it 'delegates attributes' do
      expect(subject.origin).to eq(connection.origin)
      expect(subject.destination).to eq(connection.destination)
      expect(subject.travelers).to eq(connection.travelers)
      expect(subject.departure_date).to eq(connection.departure_date)
    end
  end

  describe '.get_days_with_fare' do
    subject { described_class.new(connection).get_days_with_fare }

    it 'obtains days and fare', :vcr do
      # TODO: How to influence vcr content
      expect(subject.keys.first).to be_kind_of(Date)
      expect(subject.values.first).to be_kind_of(Float)
    end
  end
end
