require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  before{
    @user = create(:user,email:"email@email.com",password:"password")
    @user2 = create(:user,email:"iemail@email.com",password:"password")
    @topic = create(:topic,name:"abc")
    @post = create(:post,title:"title",body:"body",user_id:1,topic_id:@topic.id)
    @comment = create(:comment,body:"comment",user_id:@user.id,commenter:@user.email,post_id:@post.id)
    sign_in @user
  }

  describe "GET #index" do
    it "returns a success response" do
      get :index,params: {id: @comment.to_param, post_id: @post.id,topic_id:@topic.id}
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: {id: @comment.to_param, post_id: @post.id,topic_id:@topic.id}
      expect(response).to render_template("edit")
      expect(response).to be_successful
    end

    it "GET #edit by other user" do
      sign_in @user2
      get :edit, params: {id: @comment.to_param, post_id: @post.id,topic_id:@topic.id}
      expect(flash[:alert]).to eq "You are not authorized to access this page."
    end
  end

  describe "PUT #update" do
    context "with valid params" do

      it "updates the requested comment" do
        put :update, params: {id: @comment.to_param,topic_id: @topic.id,post_id: @post.id,
                              comment: {commenter:'user', body:"body"}}
        expect(response).to redirect_to(topic_post_path)
        expect(flash[:success]).to eq "Comment was successfully updated."
      end

      it "redirects to the rating" do
        put :update, params: {id: @comment.to_param,topic_id: @topic.id,post_id: @post.id,
                              comment: {commenter:'user', body:"body"}}
        expect(response).to redirect_to(topic_post_path(@topic.id,@post.id))
        expect(flash[:success]).to eq "Comment was successfully updated."
      end
    end

    context "with invalid" do
      it "returns response with string" do
        put :update, params: {id: @comment.to_param,topic_id: @topic.id,post_id: @post.id,
                              comment: {commenter:'commenter', body:nil }}
        expect(@comment.body).not_to be_empty
      end

      it "updates the requested by other user" do
        sign_in @user2
        put :update, params: {id: @comment.to_param,topic_id: @topic.id,post_id: @post.id,
                              comment: {commenter:'user', body:"body"}}
        expect(flash[:alert]).to eq "You are not authorized to access this page."
      end
    end
  end

  describe "POST #create" do
    it "with valid new comment" do
      expect{ post :create, params: { topic_id:@topic.id,post_id:@post.id,
                                      comment: {commenter:'user',body:"body"} }}.to change(Comment, :count).by(1)
      expect(response).to redirect_to(topic_post_path(@topic.id,@post.id))
      expect(flash[:success]).to eq "Comment was successfully created."
    end

    it "with invalid body new comment " do
      expect{ post :create, params: { topic_id:@topic.id,post_id:@post.id,
                                      comment: {commenter:'user',body:nil} } }.to change(Comment, :count).by(0)
      expect(response).to render_template("new")
      assigns(:comment).errors.empty?.should_not be true
    end

    it "should redirects to the /post" do
      post :create, params: { id: @comment.to_param,topic_id:@topic.id,
                              post_id:@post.id, comment: {commenter:'user', body:'body'} }
      expect(response).to redirect_to(topic_post_path(@topic.id,@post.id))
      expect(flash[:success]).to eq "Comment was successfully created."
    end
  end

  describe "POST#rate_comment" do
    it "should create comment rating with remote true" do
      expect{ post :rate_comment, params: { post_id: @post.to_param,topic_id: @topic.id,
                                           id:@comment.id , rating:4},format: :js }.to change(UserCommentRating, :count).by(1).and change(Rating, :count).by(1)
      expect(response).to be_successful
    end

    it "should not create comment rating with remote true" do
      expect{ post :rate_comment, params: {post_id: @post.to_param,topic_id: @topic.id,
                                           id:@comment.id , rating:10},format: :js }.to raise_error(ActiveRecord::RecordInvalid).and change(UserCommentRating, :count).by(0).and change(Rating, :count).by(0)
      expect(response).to be_successful
    end

    it "should create comment rating with remote true" do
      expect{ post :rate_comment, params: {post_id: @post.to_param,topic_id: @topic.id,
                                           id:@comment.id , rating:4} }.to change(UserCommentRating, :count).by(1).and change(Rating, :count).by(1)
      expect(response).to redirect_to(topic_post_path(@topic,@post))
    end

    it "should not create comment rating with remote true" do
      expect{ post :rate_comment, params: {post_id: @post.to_param,topic_id: @topic.id,
                                           id:@comment.id , rating:-1} }.to raise_error(ActiveRecord::RecordInvalid).and change(UserCommentRating, :count).by(0).and change(Rating, :count).by(0)
      expect(response).to be_successful
    end
  end

  describe "GET#show_comment" do
    before{
      expect{ post :rate_comment, params: {post_id: @post.to_param,topic_id: @topic.id,
                                           id:@comment.id , rating:4} }.to change(UserCommentRating, :count).by(1).and change(Rating, :count).by(1)
      expect{ post :rate_comment, params: {post_id: @post.to_param,topic_id: @topic.id,
                                           id:@comment.id , rating:3} }.to change(UserCommentRating, :count).by(1).and change(Rating, :count).by(1)
    }
    it "should create comment rating with remote true" do
      get :show_comment, params: {post_id: @post.to_param,topic_id: @topic.id,id:@comment.id},format: :js
      expect(assigns(:check).size).to eql UserCommentRating.all.size
      expect(response).to be_successful
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested comment" do
      expect {
        delete :destroy, params: {id: @comment.to_param,post_id: @post.id,topic_id:@topic.id}
      }.to change(Comment, :count).by(-1)
      expect(flash[:destroy]).to eq "Comment was successfully destroyed."
    end

    it "destroys request by other user" do
      sign_in @user2
      put :update, params: {id: @comment.to_param,topic_id: @topic.id,post_id: @post.id,
                            comment: {commenter:'user', body:"body"}}
      expect(flash[:alert]).to eq "You are not authorized to access this page."
    end

    it "redirects to the comments list" do
      delete :destroy, params: {id: @comment.to_param,post_id: @post.id,topic_id:@topic.id}
      expect(response).to redirect_to(topic_post_path(@topic.id,@post.id))
      expect(flash[:destroy]).to eq "Comment was successfully destroyed."
    end
  end
end
