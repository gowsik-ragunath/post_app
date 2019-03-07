class EmailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(args)
    TopicMailer.send_topic_created(args).deliver
  end
end
