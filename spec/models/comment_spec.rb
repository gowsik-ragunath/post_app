require 'rails_helper'

RSpec.describe Comment, type: :model do
  
  before{
	    Topic.create!(name:"topic")
	    Tag.create!(tag:'check1')
	    Post.create!(title:'post1',body:'body of post1',tag_ids:[1],topic_id:1)
	}

  subject { described_class.create!(commenter:'user',body:'comment of user',post_id:1) }

  describe "validations" do
	
    it "commenter validation" do
	  	expect(subject).to be_valid
	  	subject.commenter = nil
	  	expect(subject).to_not be_valid
	  end
  
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
