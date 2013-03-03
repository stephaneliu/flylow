# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fare do
    price "9.99"
    association :origin, factory: :city
    association :destination_id, factory: :city
    comments "MyText"
  end
end
