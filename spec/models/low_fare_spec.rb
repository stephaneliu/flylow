require 'rails_helper'

describe LowFare do
  describe '#valid' do
    subject { described_class.new }
    specify do
      is_expected.to belong_to :destination
      is_expected.to belong_to :origin
      is_expected.to validate_presence_of :origin
      is_expected.to validate_presence_of :destination
      is_expected.to validate_presence_of :price
    end
  end
end
