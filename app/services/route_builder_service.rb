# object generates array of routes from desintations and HNL
class RouteBuilderService
  attr_reader :home, :destinations

  def initialize(*destinations)
    @destinations = destinations.flatten
    @home         = City.oahu
  end

  def self.generate(destinations)
    new(destinations).generate
  end

  def generate
    remove_destination_hnl

    destinations.each_with_object([]) do |destination, from_to|
      from_to << [destination, home]
      from_to << [home, destination]
    end
  end

  private

  def remove_destination_hnl
    destinations.reject! { |city| city.code.downcase == 'hnl' }
  end
end
