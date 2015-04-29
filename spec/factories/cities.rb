# == Schema Information
#
# Table name: cities
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  region       :string(255)
#  airport_code :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  favorite     :boolean
#

FactoryGirl.define do
  factory :city do
    sequence(:name) { |f| "city_name_#{f}" }
    region "Domestic"
    sequence(:airport_code) { ['PDX','SFO', 'SEA'].shuffle.first }

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

  factory :oahu, class: City do
    name 'Honolulu'
    airport_code 'HNL'
    region 'Domestic'
    favorite true
  end
end
