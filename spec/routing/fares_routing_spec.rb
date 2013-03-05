require "spec_helper"

describe FaresController do
  describe "routing" do

    it "routes to #index" do
      get("/fares").should route_to("fares#index")
    end

    it "routes to #new" do
      get("/fares/new").should route_to("fares#new")
    end

    it "routes to #show" do
      get("/fares/1").should route_to("fares#show", :id => "1")
    end

    it "routes to #edit" do
      get("/fares/1/edit").should route_to("fares#edit", :id => "1")
    end

    it "routes to #create" do
      post("/fares").should route_to("fares#create")
    end

    it "routes to #update" do
      put("/fares/1").should route_to("fares#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/fares/1").should route_to("fares#destroy", :id => "1")
    end

  end
end
