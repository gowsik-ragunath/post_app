require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  before{
    @user = create(:user,email:"email@email.com",password:"password")
    @topic = create(:topic,name:"abc")
    @tag = create(:tag,tag:"sample")
    @post = create(:post,title:"title",body:"body",tag_ids:[@tag.id],user_id:@user.id,topic_id:@topic.id)
    @rating = create(:rating,post_id:@post.id)
    sign_in @user
  }

  describe "GET #index" do
    it "returns a success response" do
      get :index,params: {id: @rating.to_param,topic_id:@topic.id,post_id:@post.id}
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new rating" do
        expect{ post :create, params: {topic_id:@topic.id,post_id:@post.id,rating: 3}
        }.to change(Rating, :count).by(1)
        expect(response).to redirect_to(topic_post_path(id:@post.id))
        expect(flash[:notice]).to eq "Rating was successfully created."
      end

      it "redirects to the /ratings" do
        expect{ post :create, params: {topic_id:@topic.id,post_id:@post.id,rating: 3}
        }.to change(Rating, :count).by(1)
        expect(response).to redirect_to(topic_post_path(id:@post.id))
        expect(flash[:notice]).to eq "Rating was successfully created."
      end
    end

    context "with invalid params" do
      it "new rating positive" do
        expect{ post :create, params: {id: @rating.to_param,topic_id:@topic.id,post_id:@post.id,rating: 6}
        }.to change(Rating, :count).by(0)
        expect(response).to render_template("new")
        assigns(:rating).errors.empty?.should_not be true
      end

      it "new rating negative" do
        expect{ post :create, params: {id: @rating.to_param,topic_id:@topic.id,post_id:@post.id,rating: -6}
        }.to change(Rating, :count).by(0)
        expect(response).to render_template("new")
        assigns(:rating).errors.empty?.should_not be true
      end

      it "new rating string" do
        expect{ post :create, params: {id: @rating.to_param,topic_id:@topic.id,post_id:@post.id,rating: '-6'}
        }.to change(Rating, :count).by(0)
        expect(response).to render_template("new")
        assigns(:rating).errors.empty?.should_not be true
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested rating" do
      expect {
        delete :destroy, params: {id: @rating.to_param,topic_id:@topic.id,post_id:@post.id}
      }.to change(Rating, :count).by(-1)
      expect(flash[:notice]).to eq "Rating was successfully destroyed."
    end

    it "redirects to the comments list" do
      delete :destroy, params: {id: @post.to_param,topic_id:@topic.id,post_id:@post.id}
      expect(response).to redirect_to(topic_post_path(@topic.id))
      expect(flash[:notice]).to eq "Rating was successfully destroyed."
    end
  end
end

