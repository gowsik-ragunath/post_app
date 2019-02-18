require 'rails_helper'

RSpec.describe AuthenticationsController, type: :controller do
  before{
    @user = create(:user,email:"email@email.com",password:"password",password_confirmation:"password")
  }

  describe "GET authenticate" do
    it "valid basic auth" do
      @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('email@email.com','password')
      get :authenticate, format: :json
      expect(response.status).to eql(200)
      expect(json.keys).to contain_exactly('email','id')
      expect(json).to match({"email"=>"email@email.com", "id"=>1})
    end

    it "invalid username" do
      @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('','password1')
      get :authenticate, format: :json
      expect(response.status).to eql(200)
      expect(json.keys).to contain_exactly('error')
      expect(json).to match("error" => "Unauthorized access")
    end
    it "invalid password" do
      @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('email@email.co','password1')
      get :authenticate, format: :json
      expect(response.status).to eql(200)
      expect(json.keys).to contain_exactly('error')
      expect(json).to match("error" => "Unauthorized access")
    end
  end
end
