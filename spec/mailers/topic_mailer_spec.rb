require "rails_helper"

RSpec.describe TopicMailer, type: :mailer do
  before{
    @user = create(:user)
    @topic = create(:topic)
    @arg = {user_id: @user.id, topic_name: @topic.name}
  }
  describe "topic creation" do
    let(:mail) { TopicMailer.send_topic_created(@arg.stringify_keys) }

    it "renders the header" do
      expect(mail.subject).to eq("topic created")
      expect(mail.to).to eq(["user@test.com"])
      expect(mail.from).to eq(["gowsikvragunath@gmail.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to have_content("Hi user@test.com")
      expect(mail.body.encoded).to have_content("Your topic was created")
    end
  end
end
