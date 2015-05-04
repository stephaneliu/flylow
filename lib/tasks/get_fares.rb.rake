namespace :get_fares do

  # HNL -> PDX - return flight  == PDX -> HNL
  desc "Task to verify that outbout and return flights cost the same regardless of origin"
  task verify_price_equality: :setup_logger do
    origin, destination = "HNL", "PDX"
    scraper             = Scrap.new(origin, destination, departure_date: 1.month.from_now)
    fares               = []

    [[origin, destination], [destination, origin]].each_with_object(fares) do |to_from, fares|
      fares << scraper.get_days_with_fare(outbound=true).first[1]
      fares << scraper.get_days_with_fare(outbound=false).first[1]
    end
    puts "True! Outbound and Return fares are the same!" if fares.uniq.size == 2
  end

  desc "Obtain fares for cities"
  task for_domestics: :setup_logger do
    start_time = Time.now
    Rails.logger.info "####### Start Domestic: #{start_time.to_s(:db)} #######"

    connection = DomesticFareConnectionService.new
    parser     = DomesticFareParserService.new
    routes     = RouteBuilderService.generate(City.favorites.domestic)
    fetcher    = FareFetcherService.new(connection, parser, routes)
    fetcher.fares

    end_time = Time.now
    Rails.logger.info "End Domestic: #{end_time.to_s(:db)}"
    Rails.logger.info "####### Duration: #{end_time - start_time}" 
  end

  task for_internationals: :setup_logger do
    start_time = Time.now
    Rails.logger.info "####### Start International: #{start_time.to_s(:db)} #######"

    connection = InternationalFareConnectionService.new
    parser     = InternationalFareParserService.new
    routes     = RouteBuilderService.generate(City.favorites.international, :only_one_way)
    dates      = 0.upto(12).map { |num| num.public_send(:week).public_send(:from_now) }
    fetcher    = FareFetcherService.new(connection, parser, routes, dates)
    fetcher.fares

    end_time = Time.now
    Rails.logger.info "End International: #{end_time.to_s(:db)}"
    Rails.logger.info "####### Duration: #{end_time - start_time}" 
  end

  task setup_logger: :environment do
    logger       = Logger.new(File.join(Rails.root, 'log',
                                        "#{Date.tody.to_s(:db).underscore}_get_fares.log"), 'daily')
    logger.level = Logger::INFO
    Rails.logger = logger
  end

end
