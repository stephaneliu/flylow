# Object provides single representation of low upcoming fare for application
class LowUpcomingFareQuery
  attr_reader :low_upcoming_fares

  def initialize(origin, destination, departure = true)
    depart_from, return_from = departure ? [origin, destination] : [destination, origin]
    @low_upcoming_fares      = Fare.where(origin_id: depart_from, destination_id: return_from)
  end

  def find_all(updated_since, return_after)
    low_upcoming_fares
      .where('updated_at > ?', updated_since)
      .where('departure_date > ?', return_after)
      .order(:price)
  end
end
