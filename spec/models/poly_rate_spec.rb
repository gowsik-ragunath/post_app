require 'rails_helper'

RSpec.describe PolyRate, type: :model do
    before{
      @user = create(:user,email:"email@email.com",password:"password")
      @topic = create(:topic,name:"topic")
      @tag = create(:tag)
      @tag2 = create(:tag,tag:'check1')
      @post = create(:post,topic_id:@topic.id,user_id:@user.id)
    }

    subject { described_class.create!(rating:4,rateable_id: @post.id,rateable_type: 'Post',user_id:@user.id) }

    describe "validations" do
      it "validation for rating by enum" do
        expect(subject).to be_valid
        subject.rating = PolyRate.rating_as["four"]
        expect(subject.rating).to eql(4)
      end

      it "validation for valid rating by enum" do
        expect(subject).to be_valid
        subject.rating = PolyRate.rating_as["one"]
        expect(subject).to be_valid
      end

      it "validation for rating by unknow enum" do
        expect(subject).to be_valid
        subject.rating = PolyRate.rating_as["six"]
        expect(subject.rating).to eql(nil)
      end
    end
    describe "validate uniqueness for comment" do
      before{
        @comment = create(:comment,post_id: @post.id, user_id: @user.id)
        @comment.poly_rates.create(rating:4)
      }
      it "validate uniqueness" do
        expect{ @comment.poly_rates.create(rating:4) }.to change(PolyRate, :count).by(0)
      end
    end
end
