class Scraper

  def initialize
    agent = Mechanize.new
    @page = agent.get "https://fly.hawaiianairlines.com/reservations"
  end

  def page
    @page
  end
end
