require 'rails_helper'

RSpec.describe CommentsController, type: :controller do


  before{
    @topic = Topic.create!(name:"abc")
    @post = @topic.posts.create!(title:"title",body:"body")
    @comment = @post.comments.create!(commenter:"user",body:"comment")
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
  end

  describe "DELETE #destroy" do
    it "destroys the requested comment" do

      expect {
        delete :destroy, params: {id: @comment.to_param,post_id: @post.id,topic_id:@topic.id}, session: valid_session
      }.to change(Comment, :count).by(-1)
    end

    it "redirects to the comments list" do
      delete :destroy, params: {id: @comment.to_param,post_id: @post.id,topic_id:@topic.id}, session: valid_session
      expect(response).to redirect_to(topic_post_path(@topic.id,@post.id))
    end
  end

end
