class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :except => [:index,:show]

  rescue_from CanCan::AccessDenied do |exception|
      redirect_to main_app.root_url, alert: exception.message
  end

end
