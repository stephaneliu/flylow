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

require 'rails_helper'

RSpec.describe LeadTimeFare, type: :model do
  subject(:model) { described_class.new }

  describe 'relationships' do
    specify do
      is_expected.to belong_to(:origin).class_name('City')
      is_expected.to belong_to(:destination).class_name('City')
    end
  end

  describe 'validataions' do
    specify do
      is_expected.to validate_presence_of(:origin)
      is_expected.to validate_presence_of(:destination)
      is_expected.to validate_presence_of(:lead_days)
    end
  end
end
