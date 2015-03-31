FactoryGirl.define do
  factory :city do
    sequence(:name) { |f| "city_name_#{f}" }
    region "Domestic"
    sequence(:airport_code) { ['PDX','SFO', 'SEA'].shuffle.first }
    airport_code "PDX"

    trait :favorite do
      favorite true
    end

    trait :domestic do
      region 'Domestic'
    end

    trait :international do
      region 'International'
    end

    factory :favorite_city, traits: [:favorite]
    factory :domestic_city, traits: [:domestic]
    factory :international_city, traits: [:international]
  end
end
