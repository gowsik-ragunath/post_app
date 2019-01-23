require 'rails_helper'

RSpec.describe Topic, type: :model do
  

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
  		Post.create!(title:'post1',body:'body of post1',tag_ids:[1],topic_id:1)
  		Post.create!(title:'post2',body:'body of post2',tag_ids:[1],topic_id:1)
  		puts "before deleting topic post count: " + Post.count.to_s
  		expect { subject.destroy }.to change{ Post.count }
  		puts "after deleting topic post count: " + Post.count.to_s
  		
  	end
  end
end
