class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, :except => [:index,:show, :show_comment, :show_details, :device_detect]

  rescue_from CanCan::AccessDenied do |exception|
      redirect_to main_app.root_url, alert: exception.message
  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      basic_auth=User.find_by_email(username)
      if basic_auth && basic_auth.valid_password?(password)
        sign_in :user, basic_auth
        render json: {email: current_user.email, id: current_user.id}
      else
        render json: {error: "Unauthorized access" }
      end
    end
  end

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
