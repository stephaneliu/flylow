FactoryGirl.define do
  factory :city do
    sequence(:name) { |f| "city_name_#{f}" }
    region "Domestic"
    airport_code "HNL"
    
    trait :favorite do
      favorite true
    end

    factory :favorite_city, traits: [:favorite]
  end
end
