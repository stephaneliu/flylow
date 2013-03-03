class HomeController < ApplicationController

  skip_authorization_check

  def index
    @favorites = City.favorites
  end
end
