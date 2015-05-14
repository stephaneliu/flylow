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

# Object stores lead time data for fares
class LeadTimeFare < ActiveRecord::Base
  belongs_to :origin, class_name: 'City'
  belongs_to :destination, class_name: 'City'

  validates :origin, :destination, :lead_days, presence: true
end
