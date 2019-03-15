require 'rails_helper'

RSpec.describe UserCommentRating, type: :model do

  before{
    @user = User.create!(email:"email@email.com",password:"password",password_confirmation:"password")
    @topic = Topic.create!(name:"topic")
    @topic.posts.create!(title:'post1',body:'body of post1',topic_id:1,user_id:1)
    @comment = create(:comment,commenter:@user.email, body:"comment rating",post_id:1,user_id:1)
    @rating = create(:rating,rating: 5)
  }

  subject { described_class.create!(rating_id:@rating.id ,comment_id: @comment.id ,user_id: @user.id ) }

  describe "validating comment rating" do
    before{
      @rating1 = Rating.create!(rating: 5)
    }
    it "if user rate same comment again should fail" do
      subject
      expect{ described_class.create!(rating_id: @rating1.id,comment_id: @comment.id,user_id: @user.id) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

end
