class DevicesController < ApplicationController
  before_action :authenticate, if: Proc.new { |c| c.request.format.json? }
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

  def authenticate_user
    if current_user
      render json: {response: { email: current_user.email, id: current_user.id} }, status: :ok
    end
  end
end
