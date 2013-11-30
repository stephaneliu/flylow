namespace :get_fares do

  # HNL -> PDX - return flight  == PDX -> HNL
  desc "Task to verify that outbout and return flights cost the same regardless of origin"
  task verify_price_equality: :environment do
    origin, destination = "HNL", "PDX"
    scraper             = Scrap.new(origin, destination, departure_date: 1.month.from_now)
    fares               = []

    [[origin, destination], [destination, origin]].each_with_object(fares) do |to_from, fares|
      fares << scraper.get_days_with_fare(outbound=true).first[1]
      fares << scraper.get_days_with_fare(outbound=false).first[1]
    end
    puts "True! Outbound and Return fares are the same!" if fares.uniq.size == 2
  end

  desc "Obtain fares for cities"
  task :for_cities => :obtain_fares do
    Rake::Task['cache:fragments:delete'].invoke
  end

  task obtain_fares: :environment do 
    debug   = false
    cities  = City.favorites
    oahu    = City.oahu

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
  end
  
end
