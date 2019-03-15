require 'rails_helper'

RSpec.describe Post, type: :model do
  before{
    @user = create(:user,email:"email@email.com",password:"password")
    @topic = create(:topic,name:"topic")
    @tag = create(:tag)
    @tag2 = create(:tag,tag:'check1')
  }

  subject { described_class.create!(title:'post1',body:'body of post1',tag_ids:[@tag.id,@tag2.id],topic_id:@topic.id,user_id:@user.id) }

  describe "validations" do
    it "title validation" do
      expect(subject).to be_valid
      subject.title = nil
      expect(subject).to_not be_valid
    end

    it "title validation for min length" do
      should validate_length_of(:title).is_at_least(3)
    end

    it "title validation for max length" do
      should validate_length_of(:title).is_at_most(20)
    end

    it "body validation" do
      expect(subject).to be_valid
      subject.body = nil
      expect(subject).to_not be_valid
    end

    it "body validation for min length" do
      should validate_length_of(:body).is_at_least(3)
    end

    it "body validation for max length" do
      should validate_length_of(:body).is_at_most(250)
    end

    it "tag_ids validation" do
      expect(subject).to be_valid
      subject.tag_ids = nil
      expect(subject).to be_valid
    end

    it "topic_id validation" do
      expect(subject).to be_valid
      subject.topic_id = nil
      expect(subject).to_not be_valid
    end
  end

  describe "paperclip image" do
    it { should validate_attachment_content_type(:image).
        allowing('image/png').
        allowing('image/jpeg')
    }

    it { should validate_attachment_size(:image).
        less_than(2.megabytes) }
    it{
      expect(subject).to be_valid
      subject.image = File.new("spec/support/wizard.gif")
      expect(subject).not_to be_valid
    }
  end

  describe "destroy" do
    before{
      create(:comment,user_id:@user.id,commenter:@user.email,post_id:subject.id)
      create(:comment,body:"comment",user_id:@user.id,commenter:@user.email,post_id:subject.id)
      create(:rating,post_id:subject.id)
      create(:rating,rating:2,post_id:subject.id)
      create(:rating,rating:4,post_id:subject.id)
    }
    it "comment , tag delete by post dependency" do
      expect(subject).to be_valid
      expect { subject.destroy }.to change{ Comment.count }.and change{ Rating.count }
    end
  end
end
