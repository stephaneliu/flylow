class FareStatistic

  attr_reader :origin, :destination, :low_outbound_price, :low_return_price,
    :departure_dates, :return_dates

  def initialize(params) 
    @origin             = params[:origin]
    @destination        = params[:destination]
    @low_outbound_price = params[:low_outbound_price]
    @low_return_price   = params[:low_return_price]
    @departure_dates    = params[:departure_dates]
    @return_dates       = params[:return_dates]
  end

  def self.low_upcoming_fares_for(cities)
    destinations  = cities.dup
    reported      = []

    cities.sort_by {|city| city.name}.each_with_object([]) do |origin, low_fares|
      reported << origin

      destinations.each do |destination|
        next if reported.include? destination

        outbound_fares      = Fare.upcoming_for(origin, destination).order(:price)

        next if outbound_fares.empty?

        low_outbound_price  = outbound_fares.first.price
        departure_dates     = outbound_fares.reject {|fare| fare.price != low_outbound_price}.
                                map(&:departure_date)

        if low_outbound_price.present?
          return_fares      = Fare.upcoming_for(destination, origin).order(:price)
          low_return_price  = return_fares.present? ? return_fares.first.price : 0
          return_dates      = return_fares.reject {|fare| fare.price != low_return_price}.
                                map(&:departure_date)
        end

        low_fares << FareStatistic.new(origin: origin, destination: destination,
                                       low_outbound_price: low_outbound_price,
                                       low_return_price: low_return_price,
                                       departure_dates: departure_dates, 
                                       return_dates: return_dates)
      end
    end
  end


end
