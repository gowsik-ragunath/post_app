require 'rails_helper'

RSpec.describe Topic, type: :model do
	before{
		@user = create(:user,email:"email@email.com",password:"password")
	}

	subject { described_class.create!(name:'topic') }

	describe "validations" do
		it "name validation" do
			expect(subject).to be_valid
			subject.name = nil
			expect(subject).to_not be_valid
		end
	end

	describe "destroy" do
		it "post delete by topic dependency" do
			expect(subject).to be_valid
			Tag.create!(tag:'sample')
			Post.create!(title:'post1',body:'body of post1',tag_ids:[1],topic_id:1,user_id:1)
			Post.create!(title:'post2',body:'body of post2',tag_ids:[1],topic_id:1,user_id:1)
			expect { subject.destroy }.to change{ Post.count }
		end
	end
end
