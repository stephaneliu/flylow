class City < ActiveRecord::Base
  attr_accessible :name, :region, :airport_code

  def code
    self.airport_code
  end
end
