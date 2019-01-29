require 'rails_helper'


RSpec.describe PostsController, type: :controller do

  before{
    @user = User.create!(email:"email@email.com",password:"password",password_confirmation:"password")
    @topic = Topic.create!(name:"abc")
    @post = @topic.posts.create!(title:"title",body:"body",user_id:1)
    @tag = Tag.create!(tag:"sample")
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
      get :index,params: {id: @post.to_param,topic_id:@topic.id}
      expect(response).to be_successful
    end
  end


  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: {id: @post.to_param,topic_id:@topic.id}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Post" do
        expect{ post :create, params: {topic_id:@topic.id , post: {title:"title",body:"body", tag_ids: [1]}}
        }.to change(Post, :count).by(1)
      end

      it "new Post with title nil" do
        expect{ post :create, params: {topic_id:@topic.id , post: {title:"",body:"body", tag_ids: [1]}}
        }.to change(Post, :count).by(0)
      end

      it "new Post with body nil" do
        expect{ post :create, params: {topic_id:@topic.id , post: {title:"title",body:"", tag_ids: [1]}}
        }.to change(Post, :count).by(0)
      end

      it "new Post with tag_ids nil" do
        expect{ post :create, params: {topic_id:@topic.id , post: {title:"title",body:"body", tag_ids: []}}
        }.to change(Post, :count).by(1)
      end

      it "redirects to the /posts" do
        post :create, params: {topic_id:@topic.id , post: {title:"title",body:"body", tag_ids: [1]}} , session: valid_session
        expect(response).to redirect_to(topic_posts_path)
      end
    end

  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested post" do
        put :update, params: {id: @post.to_param,topic_id: @topic.id, post: {title:"update title",body:"update body", tag_ids: [1]}}, session: valid_session
        @post.reload
      end

      it "updates the requested post with invalid title" do
        put :update, params: {id: @post.to_param,topic_id: @topic.id, post: {title:"",body:"update body", tag_ids: [1]}}, session: valid_session
        expect(@post.title).not_to be_empty
        @post.reload
      end

      it "updates the requested post with invalid body" do
        put :update, params: {id: @post.to_param,topic_id: @topic.id, post: {title:"update title",body:"", tag_ids: [1]}}, session: valid_session
        expect(@post.body).not_to be_empty
        @post.reload
      end

      it "updates the requested post with no tags" do
        put :update, params: {id: @post.to_param,topic_id: @topic.id, post: {title:"update title",body:"update body", tag_ids: []}}, session: valid_session
        expect(@post.tag_ids).to be_empty
        @post.reload
      end

      it "redirects to the post" do
        put :update, params: {id: @post.to_param,topic_id: @topic.id,post: {title:"update title",body:"update body", tag_ids: [1]}}, session: valid_session
        expect(response).to redirect_to(topic_post_path)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {id: @post.to_param,topic_id: @topic.id, post: {title:"",body:"", tag_ids: []}}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested comment" do

      expect {
        delete :destroy, params: {id: @post.to_param,topic_id:@topic.id}, session: valid_session
      }.to change(Post, :count).by(-1)
    end


    it "redirects to the comments list" do
      delete :destroy, params: {id: @post.to_param,topic_id:@topic.id}, session: valid_session
      expect(response).to redirect_to(topic_posts_path(@topic.id))
    end
  end

end
