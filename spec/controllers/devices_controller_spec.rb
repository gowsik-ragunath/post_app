require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
  before{
    @user = create(:user,email:"email@email.com",password:"password",password_confirmation:"password")
  }

  describe "GET authenticate" do
    it "valid basic auth" do
      @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('email@email.com','password')
      post :authenticate_user, format: :json
      expect(response.status).to eql(200)
      expect(json.keys).to contain_exactly('response')
      expect(json).to match("response" => {"email"=>"email@email.com", "id"=>1})
    end

    it "invalid username" do
      @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('','password1')
      post :authenticate_user, format: :json
      expect(response.status).to eql(401)
      expect(json.keys).to contain_exactly('error')
      expect(json).to match("error" => "Unauthorized access")
    end
    it "invalid password" do
      @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('email@email.co','password1')
      post :authenticate_user, format: :json
      expect(response.status).to eql(401)
      expect(json.keys).to contain_exactly('error')
      expect(json).to match("error" => "Unauthorized access")
    end
  end

  describe "GET#device" do
    context "web request auth passed" do
      before{
        @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('email@email.com','password')
      }

      it "should redirect to google" do
        request.env['HTTP_USER_AGENT'] = 'android'
        get :device_detect
        expect(response).to redirect_to("https://play.google.com/store")
      end

      it "should redirect to google" do
        request.env['HTTP_USER_AGENT'] = 'iphone'
        get :device_detect
        expect(response).to redirect_to("https://www.apple.com/in/ios/app-store/")
      end

      it "should redirect to google" do
        request.env['HTTP_USER_AGENT'] = 'Mozilla'
        get :device_detect
        expect(response).to redirect_to("https://www.google.com/")
      end
    end

    context "api call with json response" do
      before{
        @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('email@email.com','password')
      }

      it "should return type for android" do
        request.env['HTTP_USER_AGENT'] = 'android'
        get :device_detect,format: :json
        expect(response.status).to eql(200)
        expect(json.keys).to contain_exactly('type')
        expect(json).to match({"type" => "android"})
      end

      it "should return type for iphone" do
        request.env['HTTP_USER_AGENT'] = 'iphone'
        get :device_detect,format: :json
        expect(response.status).to eql(200)
        expect(json.keys).to contain_exactly('type')
        expect(json).to match({"type" => "iphone"})
      end

      it "should return type for desktop" do
        request.env['HTTP_USER_AGENT'] = 'Mozilla'
        get :device_detect,format: :json
        expect(response.status).to eql(200)
        expect(json.keys).to contain_exactly('type')
        expect(json).to match({"type" => "desktop"})
      end
    end

    context "web request auth failed" do
      before{
        @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('','')
      }
      it "should failed with unauthorized access" do
        request.env['HTTP_USER_AGENT'] = 'Mozilla'
        get :device_detect,format: :json
        expect(response.status).to eql 401
        expect(json.keys).to contain_exactly('error')
        expect(json).to match("error" => "Unauthorized access")
      end
    end
  end

end
