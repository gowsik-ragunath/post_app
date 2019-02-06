require 'rails_helper'


RSpec.describe ApplicationController, type: :controller do


  before{
    @user = User.create!(email:"email@email.com",password:"password",password_confirmation:"password")
  }

  describe "GET authenticate" do
    it "valid basic auth" do
      @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('email@email.com','password')
      get :authenticate, format: :json
      expect(JSON.parse(response.body)).to eql({"email"=>"email@email.com", "id"=>1})
      expect(response.status).to eql(200)
    end

    it "invalid basic auth" do
      @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('','password1')
      get :authenticate, format: :json
      expect(JSON.parse(response.body)).to eql("error" => "You need to sign in or sign up before continuing.")
      expect(response.status).to eql(401)
    end
    it "invalid basic auth" do
      @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('email@email.co','password1')
      get :authenticate, format: :json
      expect(JSON.parse(response.body)).to eql("error" => "Invalid Email or password.")
      expect(response.status).to eql(401)
    end
  end

end
