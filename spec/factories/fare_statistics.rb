
FactoryGirl.define do
  factory :fare_statistic do
    skip_create # non active_record - PORO

    origin "Origin"
    destination "Destination"
    low_outbound_price 200.00
    low_return_price 300.00
    departure_dates [Time.now.to_date]
    return_dates [Time.now.to_date]
    checked_on  Time.now

    initialize_with { new(attributes) }
  end
end
