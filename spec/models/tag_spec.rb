require 'rails_helper'

RSpec.describe Tag, type: :model do
  
	subject{described_class.create!(tag:'check_tag')}

	before{
	    Topic.create!(name:"topic")
	}

  describe "uniqueness of tag" do
    it "validates uniqueness of tag" do
			described_class.create!(tag:'check_tag')
			check = described_class.new(tag:'check_tag')
			expect(check).not_to be_valid
    end
  end

  describe "destroy" do
  	it "tag delete by tag dependency" do

      expect(subject).to be_valid
	  	Post.create!(title:'post1',body:'body of post1',tag_ids:[1],topic_id:1)
      
  		puts "before deleting post tag count: " + Tag.count.to_s
      	
  		expect { subject.destroy }.to change { Tag.count }
		
		puts "after deleting post tag count: " + Tag.count.to_s
    end
  end

end
