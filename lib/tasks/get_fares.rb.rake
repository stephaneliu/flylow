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
  task for_cities: :obtain_fares do
    Rake::Task['cache:fragments:delete'].invoke
  end

  task obtain_fares: :setup_logger do 
    start_time = Time.now
    Rails.logger.info "####### Start: #{start_time.to_s(:db)} #######"
    connection = DomesticFareConnectionService.new
    parser     = DomesticFareParserService.new
    routes     = RouteBuilderService.generate(City.favorites)
    fetcher    = FareFetcherService.new(connection, parser, routes)
    fetcher.fares

    end_time = Time.now
    Rails.logger.info "End: #{end_time.to_s(:db)}"
    Rails.logger.info "####### Duration: #{end_time - start_time}" 
  end

  task setup_logger: :environment do
    logger       = Logger.new(File.join(Rails.root, 'log', 'get_fares.log'), 'daily')
    logger.level = Logger::INFO
    Rails.logger = logger
  end

end
