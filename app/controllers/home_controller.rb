# Object currently has no use
class HomeController < ApplicationController
  before_action :authorize_public_area!

  def index
    # @favorites = City.favorites
  end

  def whats_new
  end
end
