module ApplicationHelper
  def devise_mapping
    @devise_mapping ||= request.env["devise.mapping"]
  end

  def user_mail(model)
    User.find(model).email
  end
end
