require 'rails_helper'

RSpec.describe CommentsController, type: :controller do


  before{
    @user = User.create!(email:"email@email.com",password:"password",password_confirmation:"password")
    @user2 = User.create!(email:"iemail@email.com",password:"password",password_confirmation:"password")
    @topic = Topic.create!(name:"abc")
    @post = @topic.posts.create!(title:"title",body:"body",user_id:1)
    @comment = @post.comments.create!(body:"comment",user_id:1)
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
      get :index,params: {id: @comment.to_param, post_id: @post.id,topic_id:@topic.id}
      expect(response).to be_successful
    end
  end


  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: {id: @comment.to_param, post_id: @post.id,topic_id:@topic.id}, session: valid_session
      expect(response).to be_successful
    end

    it "GET #edit by other user" do
      sign_in @user2
      get :edit, params: {id: @comment.to_param, post_id: @post.id,topic_id:@topic.id}, session: valid_session
      expect(flash[:alert]).to eq "You are not authorized to access this page."
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested comment" do
        put :update, params: {id: @comment.to_param,topic_id: @topic.id,post_id: @post.id, comment: {commenter:'user', body:"body"}}, session: valid_session
        @comment.reload
      end

      it "redirects to the rating" do
        put :update, params: {id: @comment.to_param,topic_id: @topic.id,post_id: @post.id,comment: {commenter:'user', body:"body"}}, session: valid_session
        expect(response).to redirect_to(topic_post_path(@topic.id,@post.id))
      end
    end

    it "updates the requested by other user" do
      sign_in @user2
      put :update, params: {id: @comment.to_param,topic_id: @topic.id,post_id: @post.id,comment: {commenter:'user', body:"body"}}, session: valid_session
      expect(flash[:alert]).to eq "You are not authorized to access this page."
    end

    context "with invalid params" do
      it "returns response with string" do
        put :update, params: {id: @comment.to_param,topic_id: @topic.id,post_id: @post.id, comment: {commenter:'commenter', body:nil }}, session: valid_session
        expect(@comment.body).not_to be_empty
      end

    end
  end



  describe "POST #create" do
    context "with valid params" do
      it "creates a new comment" do
        expect{ post :create, params: {topic_id:@topic.id,post_id:@post.id,comment: {commenter:'user',body:"body"}}
        }.to change(Comment, :count).by(1)
      end

      it "new comment with invalid body" do
        expect{ post :create, params: {topic_id:@topic.id,post_id:@post.id,comment: {commenter:'user',body:nil}}
        }.to change(Comment, :count).by(0)
      end

      it "redirects to the /post" do
        post :create, params: {id: @comment.to_param,topic_id:@topic.id,post_id:@post.id,comment: {commenter:'user', body:'body'}} , session: valid_session
        expect(response).to redirect_to(topic_post_path(@topic.id,@post.id))
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested comment" do
      expect {
        delete :destroy, params: {id: @comment.to_param,post_id: @post.id,topic_id:@topic.id}, session: valid_session
      }.to change(Comment, :count).by(-1)
    end

    it "destroys request by other user" do
      sign_in @user2
      put :update, params: {id: @comment.to_param,topic_id: @topic.id,post_id: @post.id,comment: {commenter:'user', body:"body"}}, session: valid_session
      expect(flash[:alert]).to eq "You are not authorized to access this page."
    end

    it "redirects to the comments list" do
      delete :destroy, params: {id: @comment.to_param,post_id: @post.id,topic_id:@topic.id}, session: valid_session
      expect(response).to redirect_to(topic_post_path(@topic.id,@post.id))
    end
  end

end
