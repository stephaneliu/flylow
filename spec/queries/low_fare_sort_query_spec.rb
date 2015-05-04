require 'rails_helper'

RSpec.describe LowFareSortQuery do
  let!(:low_fare)          { create :low_fare }
  let!(:fav_origin)        { create :favorite_city }
  let!(:fav_dest)          { create :favorite_city }
  let!(:favorite_low_fare) { create :low_fare, origin: fav_origin, destination: fav_dest }

  subject(:query)         { described_class.new }

  describe '#find_all' do
    subject(:find_all) { query.find_all }

    specify do
      expect(find_all).to include(favorite_low_fare),
                          "expected query to include favorite city origin & destination"
      expect(find_all).to_not include(low_fare),
                              "expected query to not include non-favorite origin & destination"
    end
  end
end
