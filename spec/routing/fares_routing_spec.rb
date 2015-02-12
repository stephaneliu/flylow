require "spec_helper"

describe FaresController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/fares")).to route_to("fares#index")
    end

  end
end
