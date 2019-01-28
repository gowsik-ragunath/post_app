require 'rails_helper'

RSpec.describe Tag, type: :model do
  
	subject{described_class.create!(tag:'check_tag')}

	before{
	    Topic.create!(name:"topic")
	}

  describe "uniqueness of tag" do
		it "validates presence of tag" do
			expect(subject).to be_valid
      subject.tag = nil
      expect(subject).not_to be_valid
		end
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
  		expect { subject.destroy }.to change { Tag.count }
    end
  end

end
