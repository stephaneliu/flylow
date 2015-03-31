require 'rails_helper'

RSpec.describe FareFetcherService do
  let(:logger) { Logger.new(STDOUT) }

  describe '.initialize' do
    subject { described_class.new(logger) }

    it 'accepts logger paramter' do
      expect { subject }.to_not raise_error
    end
  end

  describe 'attributes' do
    subject { described_class.new(logger) }

    it 'has attribute readers' do
    end
  end
end
