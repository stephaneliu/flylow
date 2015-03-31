class FareFetcherService
  def initialize
  end

  def holding
    debug      = false
    cities     = City.favorites
    oahu       = City.oahu
    start_time = Time.now

    Rails.logger.info "LowFare - start: #{start_time}"

    cities.each do |origin|
      months        = [1.day.from_now.localtime, 1.month.from_now, 2.months.from_now, 3.months.from_now, 4.months.from_now]
      destinations  = cities.dup.reject {|city| city == origin}
      from_oahu     = origin == oahu

      destinations.each do |destination|
        next unless (destination == oahu) or from_oahu
        months.each do |month|

          Scrap.new(origin.code, destination.code, departure_date: month, debug: debug).get_days_with_fare.each do |day, fare|
            if debug
              puts "Adding record on #{day} for #{fare}"
              puts "origin: #{origin.code} / destination: #{destination.code}"
            end

            fare = Fare.new(price: fare, departure_date: day, origin: origin, destination: destination)
            fare.smart_save
          end
          puts "#{month.month}: #{origin.name} to #{destination.name}" if debug
        end
        LowFareStatistic.new(origin, destination).create_low_fare
      end
    end

    end_time = Time.now
    Rails.logger.info ""
    Rails.logger.info "LowFare - end: #{Time.now.to_s(:long)}"
  end
end
