class FaresController < ApplicationController
  before_filter :authorize_public_area!
  # caches_action :index, cache_path: :index_cache_path.to_proc
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

    from_date         = Time.now
    to_date           = 4.weeks.from_now
    origin            = City.oahu
    uniq_destinations = Fare.select(:destination_id).includes(:destination).where.not(destination_id: origin).uniq
    @reports          = uniq_destinations.each_with_object([]) do |fare, reports|
      report            = {}
      fares             = Fare.where(destination_id: fare.destination_id, origin_id: origin)
      upcoming          = fares.where('departure_date > ?', from_date).where('departure_date < ?', to_date)
      grouped           = upcoming.group_by(&:departure_date)

      report[:low_fare] = fares.order(:price).first
      min      = upcoming.group(:departure_date).minimum(:price)
      max      = upcoming.group(:departure_date).maximum(:price)
      latest   = Hash[*grouped.map {|depart_date, fares| [depart_date, fares.sort_by(&:updated_at).last.price]}.flatten]
      # median   = Hash[*grouped.map {|depart_date, fares|
      #   [depart_date, DescriptiveStatistics::Stats.new(fares.map(&:price)).median]}
      #   .flatten]

      # mean = DescriptiveStatistics::Stats.new(median.values).mean
      #
      median = DescriptiveStatistics::Stats.new(fares.pluck(:price)).median
      mean_median = Hash[*grouped.map {|depart_date, fares| [depart_date, median] }.flatten]

      report[:chart] = [
        { name: "Highest", data: max },
        { name: "Lowest", data: min },
        { name: "Latest", data: latest },
        { name:'Average', data: mean_median},
      ]
      reports << report
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
    puts params
    low_fare        = LowFare.find(params[:fare_id])
    @low_fare_stat  = LowFareStatistic.new(low_fare.origin, low_fare.destination)
    @target         = params[:target]
  end

  protected

  def assign_js_vars
    gon.fare_details_path = fare_details_path(9999)
  end

  def index_cache_path
    # if current_user.has_role? :admin
    #   '/admin/fares'
    # else
      '/user/fares'
    # end
  end

  private

  def fare_params
    params.require(:fare).permit(:price, :departure_date, :origin_id, :destination_id,
                                 :origin, :destination, :comments)
  end
end
