class FaresController < ApplicationController
  authorize_resource
  caches_action :index, cache_path: :index_cache_path.to_proc
  before_filter :assign_js_vars, only: :index

  # GET /fares
  # GET /fares.json
  def index
    @low_fares = LowFareSortQuery.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fares }
    end
  end

  # GET /fares/1
  # GET /fares/1.json
  def show
    @fare = Fare.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fare }
    end
  end

  # GET /fares/new
  # GET /fares/new.json
  def new
    @fare = Fare.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fare }
    end
  end

  # GET /fares/1/edit
  def edit
    @fare = Fare.find(params[:id])
  end

  # POST /fares
  # POST /fares.json
  def create
    @fare = Fare.new(params[:fare])

    respond_to do |format|
      if @fare.save
        format.html { redirect_to @fare, notice: 'Fare was successfully created.' }
        format.json { render json: @fare, status: :created, location: @fare }
      else
        format.html { render action: "new" }
        format.json { render json: @fare.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fares/1
  # PUT /fares/1.json
  def update
    @fare = Fare.find(params[:id])

    respond_to do |format|
      if @fare.update_attributes(params[:fare])
        format.html { redirect_to @fare, notice: 'Fare was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fare.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fares/1
  # DELETE /fares/1.json
  def destroy
    @fare = Fare.find(params[:id])
    @fare.destroy

    respond_to do |format|
      format.html { redirect_to fares_url }
      format.json { head :no_content }
    end
  end

  def details
    fare            = Fare.find(params[:id])
    @low_fare_stat  = LowFareStatistic.new(fare.origin, fare.destination)
    @low_fare_stat.low_fare_statistics
  end

  protected

  def assign_js_vars
    gon.fare_details_path = fare_details_path(9999)
  end

  def index_cache_path
    if current_user.has_role? :admin
      '/admin/fares'
    else
      '/user/fares'
    end
  end
end
