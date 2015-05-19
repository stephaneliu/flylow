# Object parses content with fare info for international info
# departure_prices = json["Availabilities"][0]["PriceTabs"]
# return_prices = json["Availabilities"][1]["PriceTabs"]
#
# #### Note - Each 'page' will return a week of fares in the JSON
#
# Json has following structure:
# { Availabilities:
#   { 0: ##### departure
#     { PriceTabs:
#       { 0:  # 7 elements - one for each day of week
#         { Price: "388.20"},
#         { TabDate: "04/18/2013 12:00 AM" }
#       }
#     }
#   },
#   { 1: ##### return
#     # same as departure
#   }
# }
# PriceTabs has an array 0 for outbound, 1 for return.
# Each has 6 elements containing Price and TabDate.
class InternationalFareParserService < BaseFareParserService
  attr_reader :fares

  def initialize(parser = Nokogiri::HTML)
    super
    @fares = { departure: [], return: [] }
  end

  # { departure: {
  #   '05/01/2015' => '388.20', ...},
  #  return: {
  #   '05/02/2015' => '420.00', ...}
  # }
  def parse(content)
    parsed       = parser.parse(content)
    formatted    = JSON.parse(parsed)
    parsed_fares = {}

    { departure: 0, return: 1 }
      .each_with_object(parsed_fares) do |directional_label_value, date_with_fare|
      direction_label, direction_value = directional_label_value
      date_with_fare[direction_label] = parse_date_price(formatted, direction_value)
    end

    @fares = parsed_fares
  end

  def fares(departing = true)
    direction_key = departing ? :departure : :return

    @fares[direction_key]
  end

  private

  def parse_date_price(data, direction_value)
    return {} unless data["Availabilities"].present?

    data["Availabilities"][direction_value]["PriceTabs"]
      .each_with_object({}) do |row, date_and_price|
      if (formatted_date = format_date(row["TabDate"])).present?
        date_and_price[formatted_date] = format_price(row["Price"])
      end
    end
  end

  def format_date(date)
    Date.strptime(date, "%m/%d/%Y")
  rescue ArgumentError => e
    Rails.logger.error("Unexpected date format for #{self.class}: #{e.message}")
    nil
  end

  def format_price(price)
    price.to_f
  end
end
