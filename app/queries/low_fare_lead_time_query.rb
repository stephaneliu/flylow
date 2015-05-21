# Object crafts a query to determine the average days a low fare is observed
class LowFareLeadTimeQuery
  attr_reader :origin, :destination, :scope

  def initialize(origin:, destination:)
    @origin         = origin
    @destination    = destination
    @scope          = Fare.where(origin: origin, destination: destination)
  end

  def find_all_for(departure_date: Time.zone.to_date)
    scope.where(price: lowest_price)
  end

  private

  def lowest_price
    scope.order(:price).first.price
  end
end
