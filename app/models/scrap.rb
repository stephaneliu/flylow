class Scrap

  attr_accessor :origin, :destination, :travelers

  # origin / destintaion - airport.code
  def initialize(origin, destination, options={})
    @agent        = create_agent
    @origin       = origin
    @destination  = destination

    @travelers    = options[:travelers] || 2
    @start_month  = options[:start_month] || Time.now.month
    # @round_trip   = options[:round_trip] || true

    

    # @page   = @agent.get start_url
    # form    = get_form(@page)

    # fill_form(form)
    # page = agent.submit(form)

  end

  def get_fares_by_day(outbound=true)
    day_with_fare = {}
    page          = get_page(outbound)

    # non-cheap fares
    page.css('td.CalendarDayDefault').each_with_object(day_with_fare) do |day_fare, all| 
      day, fare = day_fare.content.split("$")
      puts "day: #{day} / fare: #{fare}"
      all[day]  = fare
    end
    day_with_fare
  end

  def temp_url
    "https://fly.hawaiianairlines.com/Calendar/Calendar.aspx?orig=PDX&dest=HNL&traveler=1&isDM=false&isRoundTrip=true&depDate=5/9/2013&owORob=false&isEAward=false"
  end

  def working_example
    agent = Mechanize.new
    agent.ssl_version = 'SSLv3'
    file = agent.get "https://fly.hawaiianairlines.com/Calendar/Calendar.aspx?orig=PDX&dest=HNL&traveler=1&isDM=false&isRoundTrip=true&depDate=5/9/2013&owORob=false&isEAward=false"
    page = Nokogiri::HTML.parse "<html>#{file.content}</html>"
    #page.css('td.CalendarDayDefault > div.Fare').each {|fare| fare.content}
  end

  private 

  def create_agent
    agent              = Mechanize.new
    agent.ssl_version  = 'SSLv3'
    agent
  end

  def departure_date
    tomorrow = 1.day.from_now.localtime
    "#{tomorrow.month}/#{tomorrow.day}/#{tomorrow.year.to_s[-2..-1]}"
  end

  def get_page(outbound=true)
    file = @agent.get calendar_url(outbound)
    Nokogiri::HTML.parse "<html>#{file.content}</html>"
  end

  def calendar_url(outbound=true)
    "https://fly.hawaiianairlines.com/Calendar/Calendar.aspx?orig=#{origin}&dest=#{destination}&traveler=#{travelers}&depDate=#{departure_date}&owORob=#{outbound}&isDM=false&isRoundTrip=true&isEAward=false".tap { |url| puts url}
  end

end
