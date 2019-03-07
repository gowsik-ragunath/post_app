class TopicMailer < ApplicationMailer

  def send_topic_created(args)
    @user = User.find(args['user_id'])
    @topic_name = args['topic_name']
    # mail(to:@user.email, subject: 'topic created')

    from = SendGrid::Email.new(email: 'gowsikvragunath@gmail.com')
    to = SendGrid::Email.new(email: @user.email)
    subject = 'Topic created'
    content = SendGrid::Content.new(type: 'text/html', value: render(partial: "topic_mailer/topic_created"))
    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['sendgrid_api_key'])
    @response = sg.client.mail._('send').post(request_body: mail.to_json)
    # puts @response.status_code
    # puts @response.body
    # puts @response.headers
  end
end
