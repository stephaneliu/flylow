require 'spec_helper'

describe City do

  describe '#favorites' do
    before do
      create(:city)
      create(:favorite_city)
    end

    subject { City.favorites.count }
    it      { should be 1 }
  end
end
