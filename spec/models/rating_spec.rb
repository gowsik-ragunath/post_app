require 'rails_helper'

RSpec.describe Rating, type: :model do

  before{
    @user = User.create!(email:"email@email.com",password:"password",password_confirmation:"password")
    Topic.create!(name:"topic")
    Tag.create!(tag:'check1')
    Post.create!(title:'post1',body:'body of post1',tag_ids:[1],topic_id:1,user_id:1)
    Rating.create!(rating:5,post_id:1)
    Rating.create!(rating:2,post_id:1)
    Rating.create!(rating:4,post_id:1)
  }

  subject { described_class.create!(rating:5 ,post_id:1) }


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
