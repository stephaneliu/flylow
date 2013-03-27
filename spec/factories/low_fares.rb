# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :low_fare do
    origin_id 1
    destination_id 1
    price "9.99"
  end
end
