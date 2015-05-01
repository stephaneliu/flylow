require 'rails_helper'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'routing to fares', type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/fares')).to route_to('fares#index')
    end
  end
end
