# == Schema Information
#
# Table name: fares
#
#  id             :integer          not null, primary key
#  price          :decimal(8, 2)
#  departure_date :date
#  origin_id      :integer
#  destination_id :integer
#  comments       :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

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
