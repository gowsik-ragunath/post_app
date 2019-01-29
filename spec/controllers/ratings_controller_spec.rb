require 'rails_helper'


RSpec.describe RatingsController, type: :controller do

  before{
    @user = User.create!(email:"email@email.com",password:"password",password_confirmation:"password")
    @topic = Topic.create!(name:"abc")
    Tag.create!(tag:"sample")
    @post = @topic.posts.create!(title:"title",body:"body",tag_ids:[1],user_id:1)
    @rating = @post.ratings.create!(rating:5)
    sign_in @user
  }
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }


  describe "GET #index" do
    it "returns a success response" do
      get :index,params: {id: @rating.to_param,topic_id:@topic.id,post_id:@post.id}
      expect(response).to be_successful
    end
  end


  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: {id: @rating.to_param,topic_id:@topic.id,post_id:@post.id}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new rating" do
        expect{ post :create, params: {topic_id:@topic.id,post_id:@post.id,rating: 3}
        }.to change(Rating, :count).by(1)
      end

      it "new rating with invalid params positive" do
        expect{ post :create, params: {id: @rating.to_param,topic_id:@topic.id,post_id:@post.id,rating: 6}
        }.to change(Rating, :count).by(0)
      end

      it "new rating with invalid params negative" do
        expect{ post :create, params: {id: @rating.to_param,topic_id:@topic.id,post_id:@post.id,rating: -6}
        }.to change(Rating, :count).by(0)
      end

      it "new rating with invalid params string" do
        expect{ post :create, params: {id: @rating.to_param,topic_id:@topic.id,post_id:@post.id,rating: '-6'}
        }.to change(Rating, :count).by(0)
      end

      it "redirects to the /ratings" do
        post :create, params: {id: @rating.to_param,topic_id:@topic.id,post_id:@post.id,rating: {rating:5, post_id:1}} , session: valid_session
        expect(response).to be_successful
      end
    end

  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested rating" do
        put :update, params: {id: @rating.to_param,topic_id: @topic.id,post_id: @post.id, rating: {rating:3, post_id:1}}, session: valid_session
        @rating.reload
      end

      it "redirects to the rating" do
        put :update, params: {id: @rating.to_param,topic_id: @topic.id,post_id: @post.id,rating: {rating:3, post_id:1}}, session: valid_session
        expect(response).to redirect_to(topic_post_path)
      end
    end

    context "with invalid params" do
      it "returns response with invalid int" do
        put :update, params: {id: @rating.to_param,topic_id: @topic.id,post_id: @post.id, rating:10}, session: valid_session
        expect(response).to be_successful
      end

      it "returns response with string" do
        put :update, params: {id: @rating.to_param,topic_id: @topic.id,post_id: @post.id, rating:"10"}, session: valid_session
        expect(response).to be_successful
      end

    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested rating" do
      expect {
        delete :destroy, params: {id: @rating.to_param,topic_id:@topic.id,post_id:@post.id}, session: valid_session
      }.to change(Rating, :count).by(-1)
    end

    it "redirects to the comments list" do
      delete :destroy, params: {id: @post.to_param,topic_id:@topic.id,post_id:@post.id}, session: valid_session
      expect(response).to redirect_to(topic_post_path(@topic.id))
    end
  end

end
