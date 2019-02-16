require 'rails_helper'

RSpec.describe User, type: :model do
  before{
    @topic = create(:topic,name:"topic")
  }

  subject{ described_class.create!(email:"example1@example.com",password:"password123",password_confirmation:"password123") }

  describe "validation" do
    it "creation check" do
      expect(subject).to be_valid
    end

    it "email id validation" do
      expect(subject).to be_valid
      subject.email = "eMail"
      expect(subject).not_to be_valid
    end

    it "password validation" do
      expect(subject).to be_valid
      subject.password = "123password"
      expect(subject).not_to be_valid
    end

    it "confirm_password validation" do
      expect(subject).to be_valid
      subject.password = "123password"
      expect(subject).not_to be_valid
    end

    it "admin validation" do
      expect(subject.admin).to eql(false)
    end
  end

  describe "destroy" do
    before{
      @post = create(:post,title:'post1',body:'body of post1',topic_id:@topic.id,user_id:subject.id)
      @post2 = create(:post,title:'post2',body:'body of post2',topic_id:@topic.id,user_id:subject.id)
      create(:comment,commenter:subject.email,body:'comment of user',post_id:@post.id,user_id:subject.id)
      create(:comment,commenter:subject.email,body:'comment of user',post_id:@post.id,user_id:subject.id)
      create(:comment,commenter:subject.email,body:'comment of user',post_id:@post2.id,user_id:subject.id)
      create(:comment,commenter:subject.email,body:'comment of user',post_id:@post2.id,user_id:subject.id)
    }
    it "post delete by topic dependency" do
      expect(subject).to be_valid
      expect { subject.destroy }.to change{ User.count }.and change{ Comment.count }
    end
  end
end
