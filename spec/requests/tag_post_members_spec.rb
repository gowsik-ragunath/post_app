require 'rails_helper'

RSpec.describe "TagPostMembers", type: :request do
  describe "GET /tag_post_members" do
    it "works! (now write some real specs)" do
      get tag_post_members_path
      expect(response).to have_http_status(200)
    end
  end
end
