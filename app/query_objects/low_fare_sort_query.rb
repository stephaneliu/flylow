class LowFareSortQuery
  
  def initialize(scoped=LowFare.scoped)
    @scoped = scoped
  end

  def find_all
    @scoped.order(:origin_id, :destination_id)
  end
end
