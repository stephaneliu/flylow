# Calculates the average historical price given in the last 12 months
# origin, destination, and departure date
# based on historical data
class AveragePriceCalculatorService
  attr_reader :origin, :destination, :departure_date

  def initialize(origin:, destination:, departure_date:)
    @origin         = origin
    @destination    = destination
    @departure_date = departure_date
    @fares          = base_query
    @normalizer     = NormalizeFarePriceService.new(fares: fares)
  end

  def calculate
    DescriptiveStatistics::Stats.new(normalizer.prices).mean
  end

  private

  attr_reader :fares, :normalizer

  def base_query
    Fare.where(origin: origin, destination: destination, departure_date: departure_date)
      .where('created_at > ?', 11.months.ago)
  end
end
