require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  before{
    @user = FactoryBot.create(:user,email:"email@email.com",password:"password")
    @user2 = FactoryBot.create(:user,email:"iemail@email.com",password:"password")
    @topic = FactoryBot.create(:topic, name:"abc")
    @topic1 = FactoryBot.create(:topic, name:"xyz")
    @post = FactoryBot.create(:post,title:"title",body:"body",user_id:@user.id,topic_id:@topic.id,created_at: "2019-02-14 05:36:08")
    @post1 = FactoryBot.create(:post,title:"title",body:"body",user_id:@user.id,topic_id:@topic1.id,created_at: "2019-02-14 05:36:08")
    @post2 = FactoryBot.create(:post,title:"title",body:"body",user_id:@user.id,topic_id:@topic1.id,created_at: "2019-02-14 05:36:08")
    FactoryBot.create(:rating,rating:5,post_id: @post.id)
    FactoryBot.create(:rating,rating:2,post_id: @post.id)
    FactoryBot.create(:rating,rating:4,post_id: @post.id)
    @tag = FactoryBot.create(:tag,tag:"sample")
    FactoryBot.create(:comment,body:"comment",user_id:@user.id,commenter:@user.email,post_id:@post.id)
    @comment = FactoryBot.create(:comment,body:"comment2",user_id:@user2.id,commenter:@user2.email,post_id:@post.id)
    sign_in @user
  }

  describe "GET #index" do
    context "with html request" do
      it "returns a success response without topic id" do
        get :index
        expect(response).to render_template("index")
        expect(response.request.path_info).to eql("/posts")
        expect(response).to be_successful
      end

      it "returns a success response with topic id" do
        get :index,params: {id: @post.to_param,topic_id:@topic.id}
        expect(response).to render_template("index")
        expect(response.request.path_info).to eql("/topics/"+@topic.id.to_s+"/posts")
        expect(response).to be_successful
      end
    end

    context "with js request and constraints" do
      it "should return active records with posts created in the given date range without topic_id" do
        get :index, params: { date_from: Date.yesterday, date_to: Date.today },format: :js
        expect(response).to render_template("index")
        expect(assigns(:posts).size).to eql(Post.content_filter(Date.yesterday, Date.today).size)
      end

      it "should return active records with posts created in the given date range without topic_id" do
        get :index, params: { date_from:  Date.tomorrow , date_to: Date.yesterday },format: :js
        expect(response).to render_template("index")
        expect(response.body).to match("Give date is out of range")
      end

      it "should return active records with posts created in the given date range without topic_id" do
        get :index, params: { date_from:  "2007-10-10" , date_to: "2007-11-10"},format: :js
        expect(response).to render_template("index")
        expect(response.body).to match("No records were created in given date")
      end

      it "should return active records with posts created in the given date range with topic_id" do
        get :index, params: {topic_id:@topic.id, date_from: Date.yesterday, date_to: Date.today },format: :js
        expect(response).to render_template("index")
        expect(assigns(:posts).size).to eql(@topic.posts.content_filter(Date.yesterday,Date.today).size)
      end
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: {id: @post.to_param,topic_id:@topic.id}
      expect(response).to render_template("edit")
      expect(response).to be_successful
    end

    it "GET #edit by other user" do
      sign_in @user2
      get :edit, params: {id: @post.to_param,topic_id:@topic.id}
      expect(flash[:alert]).to eq "You are not authorized to access this page."
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Post" do
        expect{ post :create, params: {topic_id:@topic.id , post: {title:"title",body:"body", tag_ids: [1]}}
        }.to change(Post, :count).by(1)
        expect(response).to redirect_to(topic_posts_path)
        expect(flash[:notice]).to eq "Post was successfully created."
      end

      it "ajax creation form successful" do
        expect{ post :create, params: { topic_id:@topic.id ,post: {title:"title",body:"body", tag_ids: [1],
                                                                   tag_attributes: {tag: 'new_tag'}}},format: :js }.to change(Post, :count).by(1)
        expect(response).to be_successful
      end
    end

    context "with invalid params new post" do
      it "with title nil" do
        expect{ post :create, params: {topic_id:@topic.id , post: {title:"",body:"body", tag_ids: [1]}}
        }.to change(Post, :count).by(0)
        expect(response).to render_template("new")
        assigns(:post).errors.empty?.should_not be true
      end

      it "with body nil" do
        expect{ post :create, params: {topic_id:@topic.id , post: {title:"title",body:"", tag_ids: [1]}}
        }.to change(Post, :count).by(0)
        expect(response).to render_template("new")
        assigns(:post).errors.empty?.should_not be true
      end

      it "with tag_ids nil" do
        expect{ post :create, params: {topic_id:@topic.id ,post: {title:"title",body:"body",
                                                                  tag_ids: []}}}.to change(Post, :count).by(1)
        expect(response).to redirect_to(topic_posts_path)
        expect(flash[:notice]).to eq "Post was successfully created."
      end

      it "ajax title with more than 20 char" do
        expect{ post :create, params: { topic_id:@topic.id ,post: {title:"1234567890123456789012",body:"body", tag_ids: [1],
                                                                   tag_attributes: {tag: 'new_tag'}}},format: :js }.to change(Post, :count).by(0)
        assigns(:post).errors.empty?.should_not be true
        expect(response).to be_successful
      end

      it "ajax creation form failed" do
        expect{ post :create, params: {topic_id:@topic.id , post: {title:"",body:"", tag_ids: [1],
                                                                   tag_attributes: {tag: 'new_tag'}}},format: :js }.to change(Post, :count).by(0)
        assigns(:post).errors.empty?.should_not be true
        expect(response).to be_successful
      end

      it "redirects to the /posts" do
        post :create, params: {topic_id:@topic.id , post: {title:"title",body:"body", tag_ids: [1]}}
        expect(response).to redirect_to(topic_posts_path)
        expect(flash[:notice]).to eq "Post was successfully created."
      end
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show,params: {id: @post.to_param,topic_id:@topic.id}
      expect(response).to be_successful
    end

    context "with valid params" do
      it "updating read based upon multiple user" do
        get :status,params: {id: @post.to_param,topic_id:@topic.id},format: :js
        expect(response).to render_template("status")
        expect(@user.post_reads.size).to eql(1)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested post" do
        put :update, params: {id: @post.to_param,topic_id: @topic.id, post: {title:"update title",body:"update body",
                                                                             tag_ids: [1]}}
        expect(response).to redirect_to(topic_post_path)
        expect(flash[:notice]).to eq "Post was successfully updated."
      end

      it "updates the requested post with no tags" do
        put :update, params: {id: @post.to_param,topic_id: @topic.id, post: {title:"update title",body:"update body",
                                                                             tag_ids: []}}
        expect(response).to redirect_to(topic_post_path)
        expect(flash[:notice]).to eq "Post was successfully updated."
      end

      it "update requested post by other user" do
        sign_in @user2
        put :update, params: {id: @post.to_param,topic_id: @topic.id, post: {title:"update title",body:"update body",
                                                                             tag_ids: [1]}}
        expect(flash[:alert]).to eq "You are not authorized to access this page."
      end

      it "redirects to the post" do
        put :update, params: {id: @post.to_param,topic_id: @topic.id,post: {title:"update title",body:"update body",
                                                                            tag_ids: [1]}}
        expect(response).to redirect_to(topic_post_path)
        expect(flash[:notice]).to eq "Post was successfully updated."
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {id: @post.to_param,topic_id: @topic.id, post: {title:"",body:"", tag_ids: []}}
        expect(response).to render_template("edit")
        assigns(:post).errors.empty?.should_not be true
      end

      it "updates the requested post with invalid title" do
        put :update, params: {id: @post.to_param,topic_id: @topic.id, post: {title:"",body:"update body", tag_ids: [1]}}
        expect(response).to render_template("edit")
        assigns(:post).errors.empty?.should_not be true
      end

      it "updates the requested post with invalid body" do
        put :update, params: {id: @post.to_param,topic_id: @topic.id, post: {title:"update title",body:"", tag_ids: [1]}}
        expect(response).to render_template("edit")
        assigns(:post).errors.empty?.should_not be true
      end
    end
  end

  describe "POST #rate" do
    it "Rate a post" do
      expect{
        post :rate, params: {id: @post.to_param,topic_id: @topic.id, rating: 4 }
      }.to change(PolyRate, :count).by(1)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested post" do
      expect {
        delete :destroy, params: {id: @post.to_param,topic_id:@topic.id}
      }.to change(Post, :count).by(-1)
      expect(flash[:destroy]).to eq "Post was successfully destroyed."
    end

    it "destroys the request by other user" do
      sign_in @user2
      delete :destroy, params: {id: @post.to_param,topic_id:@topic.id}
      expect(flash[:alert]).to eq "You are not authorized to access this page."
    end

    it "redirects to the posts list" do
      delete :destroy, params: {id: @post.to_param,topic_id:@topic.id}
      expect(response).to redirect_to(topic_posts_path(@topic.id))
      expect(flash[:destroy]).to eq "Post was successfully destroyed."
    end
  end
end
