class TopicMailer < ApplicationMailer

  def topic_created(val)
    @user = User.find(val['user'])
    @topic = val['topic']
    # mail(to:@user.email, subject: 'topic created')

    from = SendGrid::Email.new(email: 'gowsikvragunath@gmail.com')
    to = SendGrid::Email.new(email: @user.email)
    subject = 'Topic created'
    content = SendGrid::Content.new(type: 'text/html', value: render(partial: "topic_mailer/topic_created", locals: {user: @user, topic: @topic}))
    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['sendgrid_api_key'])
    @response = sg.client.mail._('send').post(request_body: mail.to_json)
    # puts @response.status_code
    # puts @response.body
    # puts @response.headers
  end
end
