# Base object of connections to external sites for data scraping
class BaseConnectionService
  attr_reader :mechanize, :travelers

  def initialize(travelers = 4)
    @mechanize = mechanize_agent
    @travelers = travelers
  end

  def content
    fail NotImplementedError, "Expect to be implemented by inherited class"
  end

  protected

  def mechanize_agent
    Mechanize.new.tap { |mech| mech.ssl_version = 'SSLv3' }
  end
end
