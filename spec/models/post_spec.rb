require 'rails_helper'

RSpec.describe Post, type: :model do
  
  before{
    Topic.create!(name:"topic")
    Tag.create!(tag:'sample')
    Tag.create!(tag:'check1')
  }

  subject { described_class.create!(title:'post1',body:'body of post1',tag_ids:[1,2],topic_id:1) }

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

  describe "destroy" do

  	it "comment , tag delete by post dependency" do

      expect(subject).to be_valid
	  	Comment.create!(commenter:'user',body:'comment of user',post_id:1)
      Comment.create!(commenter:'user',body:'comment of user',post_id:1)
      
      puts "before deleting post comment count: " + Comment.count.to_s

  		expect { subject.destroy }.to change{ Comment.count}


      puts "after deleting post comment count: " + Comment.count.to_s
		
  	end
  end


end
