# 
# fare = IntFare.new
# page = fare.get_page
#
# Json has following structure: 
# { Availabilities:
#   { 0: departure
#     { PriceTabs:
#       { 0:  # 7 elements - one for each day of week
#         { Price: "388.20"},
#         { TabDate: "04/18/2013 12:00 AM" }
#       }
#     }
#   },
#   { 1: # return
#     # same as departure
#   }
# }
# PriceTabs has an array 0 for outbound, 1 for return. Each has 6 elements containing Price and TabDate.
#
class IntFare
  attr_reader :agent
  def initialize(options={})
    options         = {} unless options.is_a? Hash # ignore unless options
    @agent          = create_secure_agent
    #add_custom_cookie
    # @origin         = origin
    # @destination    = destination
    # @travelers      = options[:travelers] || 2
    # @departure_date = options[:departure_date] || 1.day.from_now.localtime
    # @debug          = options[:debug]
  end

  def get_page
    @agent.get('https://fly.hawaiianairlines.com/reservations/2/default.aspx?qrys=qres&source=&Trip=RT&departure=HNL&destination=HND&out_day=21&out_month=4&return_day=9&return_month=5&adult_no=4&lang=us')

    @agent.post('https://fly.hawaiianairlines.com/reservations/2/Availability.mvc/Flights')
  end

  def create_secure_agent
    Mechanize.new.tap {|mech| mech.ssl_version  = 'SSLv3'}
  end

  def add_custom_cookie
    raw_cookie.each do |key, value|
      cookie = Mechanize::Cookie.new(key, value)
      cookie.domain = ".hawaiianairlines.com"
      cookie.path = "/"
      @agent.cookie_jar.add(URI.parse('http://fly.hawaiianairlines.com'), cookie)
    end
  end

  # TODO - Need to obtain HALAPPS and ASP.NET_SessionId values from a valid form post???
  def raw_cookie
    { 
      "FlightSearch1.tripType" => 'RT',
      "FlightSearch1.travelers" => '2',
      "FlightSearch1.origin" => 'HNL',
      "FlightSearch1.destination" => 'HND',
      "FlightSearch1.departureDate" => '6/9/2013',
      "FlightSearch1.returnDate" => '6/19/2013',
      "FlightSearch1.altCity" => 'true',
      "HALAPPS" => 'WYZYZYSapps3CKKWK', # required
      "ASP.NET_SessionId" => 'loctxyzwqyamh3kej315fpwp', # required
      ".lang" => "us"
    }
    
    # superfluous key/values
    # "CookieCheck" => "Yes", # optional
    #"mbox" => "PC#1364083015782-718902.19_23#1366093275|check#true#1364883735|session#1364883662393-908652#1364885535",
    #"s_lv" => '1364883672327',
    # "s_cc" => "true",
    # "s_nr" => "1364883672326-Repeat",
    # "s_invisit" => "true"
  end
end
