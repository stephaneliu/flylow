# Reports on the lead times for observed low fare against depature date for favorite cities
class LeadTimeFareGeneratorService
  attr_reader :query

  def initialize(query: LowFareLeadTimeQuery)
    @query = query
  end

  # def generate_for(departure_date)
  def lead_times
    routes.each do |origin, destination|
      departure_dates.each do |depart_date|
        lead_query = query.new(origin: origin, destination: destination,
                               departure_date: depart_date)
        lead_query.find_all.each do |fare|
          LeadTimeFare.new(origin: fare.origin, destination: fare.destination,
                           departure_date: departure_date)
        end
      end
    end
  end
end
