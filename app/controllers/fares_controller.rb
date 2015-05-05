# Controller class for fares
class FaresController < ApplicationController
  before_action :authorize_public_area!

  # GET /fares
  # GET /fares.json
  def index
    @low_fares = LowFareSortQuery.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fares }
    end
  end

  def details
    @low_fare = LowFare.find(params[:fare_id])
    @target   = params[:target]
  end

  protected

  private

  def fare_params
    params.require(:fare).permit(:price, :departure_date, :origin_id,
                                 :destination_id, :origin, :destination,
                                 :comments)
  end
end
