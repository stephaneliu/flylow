class LowUpcomingFareQuery
  def initialize(origin, destination)
    @low_upcoming_fare = Fare.upcoming_for(origin, destination)
  end

  def find_all
    @low_upcoming_fare.
      where('updated_at > ?', updated_since).
      where('departure_date >= ?', return_after).
      order(:price)
  end
end
