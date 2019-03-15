require 'rails_helper'

RSpec.describe Comment, type: :model do
  before{
    @user = create(:user,email:"email@email.com",password:"password")
    @topic = create(:topic,name:"topic")
    @tag = create(:tag,tag:'check1')
    @post = create(:post,title:'post1',body:'body of post1',tag_ids:[@tag.id],user_id:@user.id,topic_id:@topic.id)
  }

  subject { described_class.create!(commenter:'user',body:'comment of user',post_id:@post.id,user_id:@user.id) }

  describe "validations" do
    it "body validation" do
      expect(subject).to be_valid
      subject.body = nil
      expect(subject).to_not be_valid
    end

    it "post_id validation" do
      expect(subject).to be_valid
      subject.post_id = nil
      expect(subject).to_not be_valid
    end
  end

  describe "destroy" do
    it "comment deletion" do
      expect(subject).to be_valid
      expect { subject.destroy }.to change{ Comment.count}
    end
  end
end
