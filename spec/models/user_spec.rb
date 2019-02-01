require 'rails_helper'

RSpec.describe User, type: :model do

  before{
    Topic.create!(name:"topic")
  }

  subject{ described_class.create!(email:"example@example.com",password:"password123",password_confirmation:"password123") }

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
    it "post delete by topic dependency" do

      expect(subject).to be_valid
      Post.create!(title:'post1',body:'body of post1',topic_id:1,user_id:1)
      Post.create!(title:'post2',body:'body of post2',topic_id:1,user_id:1)
      Comment.create!(commenter:'user',body:'comment of user',post_id:1,user_id:1)
      Comment.create!(commenter:'user',body:'comment of user',post_id:1,user_id:1)
      Comment.create!(commenter:'user',body:'comment of user',post_id:2,user_id:1)
      Comment.create!(commenter:'user',body:'comment of user',post_id:2,user_id:1)

      expect { subject.destroy }.to change{ User.count }.and change{ Comment.count }

    end
  end

end
