require 'rails_helper'

RSpec.describe Post, type: :model do
  
  before{
    @user = User.create!(email:"email@email.com",password:"password",password_confirmation:"password")
    Topic.create!(name:"topic")
    Tag.create!(tag:'sample')
    Tag.create!(tag:'check1')
  }

  subject { described_class.create!(title:'post1',body:'body of post1',tag_ids:[1,2],topic_id:1,user_id:1) }

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
      should validate_length_of(:title).is_at_most(25)
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

  	it "comment , tag delete by post dependency" do

      expect(subject).to be_valid
	  	Comment.create!(commenter:'user',body:'comment of user',post_id:1,user_id:1)
      Comment.create!(commenter:'user',body:'comment of user',post_id:1,user_id:1)
      Rating.create!(rating:5,post_id:1)
      Rating.create!(rating:2,post_id:1)
      Rating.create!(rating:4,post_id:1)

  		expect { subject.destroy }.to change{ Comment.count }.and change{ Rating.count }

  	end
  end


end
