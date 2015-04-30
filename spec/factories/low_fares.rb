# == Schema Information
#
# Table name: low_fares
#
#  id              :integer          not null, primary key
#  origin_id       :integer
#  destination_id  :integer
#  price           :decimal(8, 2)    default(0.0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  url_reference   :string(255)
#  departure_dates :text
#  departure_price :decimal(8, 2)    default(0.0)
#  return_dates    :text
#  return_price    :decimal(8, 2)    default(0.0)
#  url             :text
#  last_checked    :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :low_fare do
    association :origin, factory: :city
    association :destination, factory: :city
    price "9.99"
  end
end
