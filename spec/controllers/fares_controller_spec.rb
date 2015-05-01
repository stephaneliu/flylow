require 'rails_helper'

describe FaresController do
  describe 'GET index' do
    it 'assigns all fares as @fares' do
      get :index, {}
      expect(assigns(:low_fares)).to_not be_nil
    end
  end
end
