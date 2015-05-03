# Interface for parsers
class BaseFareParserService
  attr_reader :parser

  def initialize(parser = Nokogiri::HTML)
    @parser = parser
  end

  def parse
    fail NotImplementedError, "Expect to be implemented by inherited class"
  end
end
