
FactoryGirl.define do
  factory :low_fare_statistic do
    skip_create # non active_record - PORO

    origin "Origin"
    destination "Destination"

    initialize_with { new(attributes) }
  end
end
