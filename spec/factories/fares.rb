# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fare do
    price "9.99"
    departure_date 1.week.from_now
    association :origin, factory: :city
    association :destination, factory: :city
    comments "MyText"
  end
end
