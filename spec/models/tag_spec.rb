require 'rails_helper'

RSpec.describe Tag, type: :model do
  
	subject{described_class.create!(tag:'check_tag')}

	before{
	    Topic.create!(name:"topic")
	}

  describe "destroy" do
  	it "tag_post_member delete by tag dependency" do

      expect(subject).to be_valid
	  	Post.create!(title:'post1',body:'body of post1',tag_ids:[1],topic_id:1)
      
  		puts "before deleting post tag_post_members count: " + Tag.count.to_s
      	
  		expect { subject.destroy }.to change { Tag.count }
		
		puts "after deleting post tag_post_members count: " + Tag.count.to_s
    end
  end

end
