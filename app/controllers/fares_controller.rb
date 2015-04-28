class FaresController < ApplicationController
  before_action :authorize_public_area!
  before_action :assign_js_vars, only: :index

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
    low_fare        = LowFare.find(params[:fare_id])
    @low_fare_stat  = LowFareStatistic.new(low_fare.origin, low_fare.destination)
    @target         = params[:target]

    @low_fare_stat.statistics
  end

  protected

  def assign_js_vars
    gon.fare_details_path = fare_details_path(9999)
  end

  private

  def fare_params
    params.require(:fare).permit(:price, :departure_date, :origin_id,
                                 :destination_id, :origin, :destination,
                                 :comments)
  end
end
