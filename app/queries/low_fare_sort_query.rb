# Object provide singularity for complex, low_fare query in app
class LowFareSortQuery
  def initialize(scoped = LowFare.all)
    @scoped = scoped
  end

  def find_all
    favorite_cities = City.favorites

    @scoped.joins('inner join cities origin on origin.id = low_fares.origin_id')
      .includes(:origin, :destination)
      .joins('inner join cities destination on destination.id = low_fares.destination_id')
      .order('origin.name, destination.name').select do |fare|
        favorite_cities.include?(fare.origin) && favorite_cities.include?(fare.destination)
      end
  end
end
