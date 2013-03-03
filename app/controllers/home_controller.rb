class HomeController < ApplicationController

  before_filter :authorize_public_area!

  def index
    @favorites = City.favorites
  end
end
