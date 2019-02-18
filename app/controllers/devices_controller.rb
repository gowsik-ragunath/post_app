class DevicesController < ApplicationController
  def device_detect
    respond_to do |format|
      if request.env['HTTP_USER_AGENT'].downcase.match(/android/)
        format.html { redirect_to 'https://play.google.com/store' }
        format.json{ render json: {type: "android"} }
      elsif request.env['HTTP_USER_AGENT'].downcase.match(/iphone/)
        format.html { redirect_to 'https://www.apple.com/in/ios/app-store/' }
        format.json { render json: {type: "iphone"} }
      else
        format.html { redirect_to 'https://www.google.com/' }
        format.json { render json: {type: "desktop"} }
      end
    end
  end
end
