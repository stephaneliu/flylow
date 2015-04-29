# == Schema Information
#
# Table name: roles
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  resource_id   :integer
#  resource_type :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# ORM object for Role
class Role < ActiveRecord::Base
  has_many :users, through: :user_roles
  belongs_to :resource, polymorphic: true
end
