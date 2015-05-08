# Reports on the lead times for observed low fare against depature date for favorite cities
class LeadTimeReportService
  attr_reader :query, :routes, :departure_dates

  def initialize(query: LowFareLeadTimeQuery, routes: [],
                 departure_dates: [Time.zone.yesterday.to_date])
    @query           = query
    @routes          = routes
    @departure_dates = departure_dates
  end
end
