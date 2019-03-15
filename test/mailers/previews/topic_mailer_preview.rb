class TopicMailerPreview < ActionMailer::Preview
  def sample_mail_preview
    TopicMailer.topic_created(User.first)
  end
end