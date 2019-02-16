class EmailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user)
    @user = user
    TopicMailer.topic_created(@user).deliver
  end
end
