require 'rails_helper'

RSpec.describe UserCommentRating, type: :model do

  before{
    @user = User.create!(email:"email@email.com",password:"password",password_confirmation:"password")
    @topic = Topic.create!(name:"topic")
    @topic.posts.create!(title:'post1',body:'body of post1',topic_id:1,user_id:1)
    Comment.create!(commenter:@user.email, body:"comment rating",post_id:1,user_id:1)
  }

  subject { described_class.create!(rating:5 ,comment_id:1,user_id:1) }

  describe "validating comment rating" do

    it "should rating by positive int and fails" do
      expect(subject).to be_valid
      subject.rating = 1
      expect(subject).to be_valid
    end

    it "should rating by positive int and fails" do
      expect(subject).to be_valid
      subject.rating = 10
      expect(subject).not_to be_valid
    end

    it "should rating by negative int and fails" do
      expect(subject).to be_valid
      subject.rating = -8
      expect(subject).not_to be_valid
    end
  end

end
