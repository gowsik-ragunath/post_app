class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, :except => [:index,:show, :show_comment, :show_details]

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

end
