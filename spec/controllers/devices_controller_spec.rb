require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
  describe "GET#device" do
    context "web request" do
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
  end
end
