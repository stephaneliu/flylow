class LowUpcomingFareQuery
  def initialize(origin, destination)
    @low_upcoming_fare = Fare.where(origin_id: origin, destination_id: destination)
  end

  def find_all(updated_since, return_after)
    @low_upcoming_fare.
      where('updated_at > ?', updated_since).
      where('departure_date > ?', return_after).
      order(:price)
  end
end
