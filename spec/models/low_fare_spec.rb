require 'spec_helper'

describe LowFare do

  describe 'as valid' do
    it { should validate_presence_of :origin }
    it { should validate_presence_of :destination }
    it { should validate_presence_of :price }
  end
end
