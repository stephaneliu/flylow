
FactoryGirl.define do
  factory :low_fare_statistic do
    skip_create # non active_record - PORO

    association :origin, factory: :city
    association :destination, factory: :city 

    initialize_with { new(origin, destination) }
  end
end
