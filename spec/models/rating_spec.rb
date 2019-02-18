require 'rails_helper'

RSpec.describe Rating, type: :model do
  before{
    @user = create(:user,email:"email@email.com",password:"password")
    @topic = create(:topic,name:"topic")
    @tag = create(:tag,tag:'check1')
    @post = create(:post,title:'post1',body:'body of post1',tag_ids:[@tag.id],topic_id:@topic.id,user_id:@user.id)
    create(:rating,rating:5,post_id:@post.id)
    create(:rating,rating:2,post_id:@post.id)
    create(:rating,rating:4,post_id:@post.id)
  }

  subject { described_class.create!(rating:5 ,post_id:@post.id) }

  describe "validation" do
    it "validation for rating by positive int" do
      expect(subject).to be_valid
      subject.rating = 10
      expect(subject).not_to be_valid
    end

    it "validation for rating by negative int" do
      expect(subject).to be_valid
      subject.rating = -8
      expect(subject).not_to be_valid
    end
  end

  describe "scope funtion validation" do
    it "order in rating" do
      Rating.rating_order.should eq(Rating.order(rating: :asc))
    end
  end

  describe "scope funtion validation" do
    it "average in rating" do
      expect(Rating.rating_average).eql?(Rating.average(:rating))
    end
  end
end
