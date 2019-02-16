class SendEmailJob < ApplicationJob
  queue_as :default

  def perform(user)
    @user = user
    TopicMailer.topic_created(@user).deliver
  end
end
