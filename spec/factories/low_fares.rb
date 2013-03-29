# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :low_fare do
    association :origin, factory: :city
    association :destination, factory: :city
    price "9.99"
  end
end
