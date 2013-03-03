class City < ActiveRecord::Base
  attr_accessible :name, :region, :airport_code

  scope :favorites, where(favorite: true)

  def code
    self.airport_code
  end
end
