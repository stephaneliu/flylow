# object generates array of routes from desintations and HNL
class RouteBuilderService
  attr_reader :home, :destinations

  def initialize(*destinations)
    @destinations = destinations.flatten
    @home         = City.oahu
  end

  def self.generate(destinations, only_one_way = false)
    new(destinations).generate(only_one_way)
  end

  def generate(only_one_way = false)
    remove_destination_hnl

    destinations.each_with_object([]) do |destination, routes|
      routes << [home, destination]
      routes << [destination, home] unless only_one_way
    end
  end

  private

  def remove_destination_hnl
    destinations.reject! { |city| city.code.downcase == 'hnl' }
  end
end
