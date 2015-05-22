# Object adds an additional price to collection for each day between created_at and updated_at
# If a fare was observed for 3 days, the fare's price would be added three time in the collection
class NormalizeFarePriceService
  attr_reader :fares

  def initialize(fares:)
    @fares = fares
  end

  def prices
    fares.each_with_object([]) do |fare, prices|
      0.upto(day_span(fare)) { prices << fare.price }
    end
  end

  private

  def day_span(fare)
    ((fare.updated_at.beginning_of_day - fare.created_at.beginning_of_day)) / 60 / 60 / 24
  end
end
