require 'rails_helper'

RSpec.describe BaseConnectionService do
  let(:base)      { described_class.new(travelers) }
  let(:travelers) { 4 }

  describe '#new' do
    let(:travelers) { 2 }

    specify do
      expect(base.mechanize).to_not be_nil
      expect(base.travelers).to eq(travelers)
    end
  end

  describe '#content' do
    specify do
      expect { base.content }.to(
        raise_error(NotImplementedError, "Expect to be implemented by inherited class"))
    end
  end
end
