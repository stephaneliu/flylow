# Object crafts a query to determine the average days a low fare is observed
class LowFareLeadTimeQuery
  attr_reader :origin, :destination, :departure_date, :scope

  def initialize(origin:, destination:, departure_date:)
    @origin         = origin
    @destination    = destination
    @departure_date = departure_date
    @scope          = Fare.where(origin: origin, destination: destination,
                                 departure_date: departure_date)
  end

  def find_all
    scope.where(price: lowest_price)
  end

  private

  def lowest_price
    scope.order(:price).first.price
  end
end
