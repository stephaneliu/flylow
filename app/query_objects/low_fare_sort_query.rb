# Object provide singularity for complex, low_fare query in app
class LowFareSortQuery
  def initialize(scoped = LowFare.all)
    @scoped = scoped
  end

  def find_all
    @scoped.joins('inner join cities origin on origin.id = low_fares.origin_id')
      .includes(:origin)
      .joins('inner join cities destination on destination.id = low_fares.destination_id')
      .order('origin.name, destination.name')
      .select('low_fares.*, origin.name as origin_name, origin.airport_code as origin_code,\
 destination.name as destination_name, destination.airport_code as destination_code')
  end
end
