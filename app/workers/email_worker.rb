class EmailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user)
    TopicMailer.topic_created(user).deliver
  end
end
