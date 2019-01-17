require "rails_helper"

RSpec.describe TagPostMembersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/tag_post_members").to route_to("tag_post_members#index")
    end

    it "routes to #new" do
      expect(:get => "/tag_post_members/new").to route_to("tag_post_members#new")
    end

    it "routes to #show" do
      expect(:get => "/tag_post_members/1").to route_to("tag_post_members#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/tag_post_members/1/edit").to route_to("tag_post_members#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/tag_post_members").to route_to("tag_post_members#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/tag_post_members/1").to route_to("tag_post_members#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/tag_post_members/1").to route_to("tag_post_members#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/tag_post_members/1").to route_to("tag_post_members#destroy", :id => "1")
    end
  end
end
