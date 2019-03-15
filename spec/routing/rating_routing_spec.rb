require "rails_helper"

RSpec.describe RatingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/topics/1/posts/1/ratings").to route_to("ratings#index", topic_id:'1',post_id:'1')
    end

    it "routes to #new" do
      expect(:get => "/topics/1/posts/1/ratings/new").to route_to("ratings#new", topic_id:'1',post_id:'1')
    end

    it "routes to #edit" do
      expect(:get => "/topics/1/posts/1/ratings/1/edit").to route_to("ratings#edit",topic_id:'1',post_id:'1' , :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/topics/1/posts/1/ratings").to route_to("ratings#create", topic_id:'1',post_id:'1')
    end

    it "routes to #destroy" do
      expect(:delete => "/topics/1/posts/1/ratings/1").to route_to("ratings#destroy",topic_id:'1' ,post_id:'1' , :id => "1")
    end
  end
end
