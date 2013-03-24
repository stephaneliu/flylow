class PagesController < HighVoltage::PagesController
  before_filter { authorize! :read, :static_pages }
end
