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
      it "validation for rating by negative int" do
        expect(subject).to be_valid
        subject.rating = -8
        expect(subject).not_to be_valid
      end

      it "validation for rating by positive int" do
        expect(subject).to be_valid
        subject.rating = 10
        expect(subject).not_to be_valid
      end

      it "validation for valid rating by positive int" do
        expect(subject).to be_valid
        subject.rating = 1
        expect(subject).to be_valid
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
