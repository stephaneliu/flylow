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

  desc "Obtain fares for favorite domestic routes"
  task :domestic, [:horizon] => :environment do |_, args|
    args.with_defaults(horizon: :near_term)

    horizon    = args[:horizon]

    setup_logger(label: "domestic_#{horizon}")

    start_time = Time.now

    Rails.logger.info "# Start | #{horizon} Domestic |"

    months          = horizons[horizon]
    months_in_words = months.map { |month| month.strftime('%m-%Y') }
    routes          = RouteBuilderService.generate(City.favorites.domestic)
    fetcher         = FareFetcherService.new(routes: routes, dates: months)

    fetcher.fares

    Rails.logger.info "# End | #{horizon} Domestic | duration: #{Time.zone.now - start_time}"
  end

  desc "Obtain fares for favorite international routes"
  task :international, [:horizon] => :environment do |_, args|
    args.with_defaults(horizon: :near_term)

    horizon = args[:horizon]

    setup_logger(label: "intl_#{horizon}")

    start_time = Time.now

    Rails.logger.info "# Start | #{horizon} International |"

    connection = InternationalFareConnectionService.new
    parser     = InternationalFareParserService.new
    routes     = RouteBuilderService.generate(City.favorites.international, :only_one_way)
    dates      = horizons(!:as_months)[horizon]
    dates      = 0.upto(12).map { |num| num.public_send(:week).public_send(:from_now) }
    fetcher    = FareFetcherService.new(connection: connection, parser: parser, routes: routes, dates: dates)

    fetcher.fares
    Rails.logger.info "# End | #{horizon} International | duration: #{Time.zone.now - start_time}"
  end


  def horizons(as_months = true)
    if as_months
      HashWithIndifferentAccess.new(near_term: week_or_month_in_range(:months, 0, 2),
                                    mid_term:  week_or_month_in_range(:months, 3, 6),
                                    long_term: week_or_month_in_range(:months, 7, 11))
    else
      HashWithIndifferentAccess.new(near_term: week_or_month_in_range(:weeks, 0, 10),
                                    mid_term:  week_or_month_in_range(:weeks, 11, 25),
                                    long_term: week_or_month_in_range(:weeks, 26, 47))
    end
  end

  def week_or_month_in_range(operator, from_start, to_end)
    from_start.upto(to_end).map do |num|
      num.send(operator.to_sym).send(:from_now)
    end
  end

  def setup_logger(label:)
    logger       = Logger.new(
      File.join(Rails.root, 'log',
                "#{Date.today.to_s(:db).underscore}_#{label}_fares.log"), 'daily')
    logger.level = Logger::INFO
    Rails.logger = logger
  end

end
