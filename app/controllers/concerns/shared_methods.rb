module SharedMethods
  extend ActiveSupport::Concern
  # @decodedVapidPublicKey = Base64.urlsafe_decode64(ENV['VAPID_PUBLIC_KEY']).bytes
  def pagination(model,per = 10)
    model.paginate(page: params[:page], per_page: per)
  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      basic_auth=User.find_by_email(username)
      if basic_auth && basic_auth.valid_password?(password)
        true
      else
        render json: { error: "Unauthorized access" }, status: 401
      end
    end
  end

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end