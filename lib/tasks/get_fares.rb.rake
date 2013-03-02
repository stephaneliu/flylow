namespace :get_fares do
  desc "Obtain fares to cities from Honolulu"
  task :from_hnl => :environment do

    cities  = City.all
    origin  = City.find_by_airport_code("HNL").id

    cities.each do |city|
      # earliest depart for current month is tomorrow
      months = [1.month.from_now.beginning_of_day.localtime]

      puts "Getting fare for #{city.airport_code}"
      months.each do |month|
        puts "Getting fare for #{month}"
        Scrap.new("HNL", city.airport_code, departure_date: month).get_days_with_fare.each do |day, fare|
          puts "Adding record on #{day} for #{fare}"
          # TODO - How should days without fares be handled? 
          if Fare.create(price: fare, departure_date: day, origin_id: origin, destination: city)
            puts "Successfully added fare for HNL -> #{city.airport_code} departing #{day}"
          else
            puts "Could not added fare for HNL -> #{city.airport_code} deparating #{day}"
          end
        end
      end
    end
  end
end
