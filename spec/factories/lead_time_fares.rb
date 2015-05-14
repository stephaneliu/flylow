# == Schema Information
#
# Table name: lead_time_fares
#
#  id             :integer          not null, primary key
#  origin_id      :integer
#  destination_id :integer
#  departure_date :date
#  price          :decimal(8, 2)
#  lead_days      :integer
#

FactoryGirl.define do
  factory :lead_time_fare do
    association :origin, factory: :city
    association :destination, factory: :city
    departure_date 1.week.from_now
    price "100"
    lead_days 1
  end
end
