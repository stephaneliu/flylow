require 'spec_helper'

RSpec.describe BaseFareParserService do
  let(:parser) { described_class.new }

  describe '#initialize' do
    subject { parser.parser }
    specify { is_expected.to eq(Nokogiri::HTML) }
  end

  describe '#parse' do
    specify do
      expect { parser.parse }
        .to raise_error(NotImplementedError, "Expect to be implemented by inherited class")
    end
  end

  describe 'accessor' do
    it 'has departure_date setter' do
      expect { parser.departure_date = Time.zone.now }.to_not raise_error
      expect(parser.departure_date)
    end
  end
end
