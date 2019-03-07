module ApplicationHelper
  def user_mail(user_id)
    User.find(user_id).email
  end
end
