require 'spec_helper'

describe UsersController, :focus do

  before do
    @user = create :user
    sign_in @user
  end

  describe "GET 'show'" do
    
    it "should be successful" do
      get :show, id: @user.id
      puts response.body
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, id: @user.id
      assigns(:user).should == @user
    end
    
  end

end
