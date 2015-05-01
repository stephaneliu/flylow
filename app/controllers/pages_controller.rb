# Object provides access to pages resources
class PagesController < HighVoltage::PagesController
  before_action { authorize! :read, :static_pages }
end
