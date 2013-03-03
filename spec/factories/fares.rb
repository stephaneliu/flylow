# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ticket do
    price "9.99"
    origin_id 1
    destination_id 1
    comments "MyText"
  end
end
