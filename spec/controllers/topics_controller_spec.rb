require 'rails_helper'

RSpec.describe TopicsController, type: :controller do

  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  before{
    @topic = Topic.create!(name:"topic")
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    login_user
    it "returns a success response" do
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    login_user
    it "returns a success response" do
      get :show, params: {id: @topic.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    login_user
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    login_user
    it "returns a success response" do
      get :edit, params: {id: @topic.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end


    describe "POST #create" do
      login_user
    context "with valid params" do
      it "creates a new Topic" do
        expect {
          post :create, params: {topic: {name:"sddsa"} }, session: valid_session
        }.to change(Topic, :count).by(1)
      end

      it "creates a new Topic invalid param" do
        expect {
          post :create, params: {topic: {name:nil} }, session: valid_session
        }.to change(Topic, :count).by(0)
      end

      it "redirects to the created topic" do
        post :create, params: {topic: {name:"DSa"}} , session: valid_session
        expect(response).to redirect_to(topics_path)
      end
    end

  end

  describe "PUT #update" do
    login_user
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested topic" do
        put :update, params: {id: @topic.to_param, topic:{name:'update tag'}}, session: valid_session
        @topic.reload
      end

      it "redirects to the topic" do
        put :update, params: {id: @topic.to_param, topic: {name:"valid_attributes"}}, session: valid_session
        expect(response).to redirect_to(@topic)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {id: @topic.to_param , topic: {name:nil}}, session: valid_session
        expect(@topic.name).not_to be_blank
      end
    end
  end

  describe "DELETE #destroy" do
    login_user
    it "destroys the requested topic" do
      expect {
        delete :destroy, params: {id: @topic.to_param}, session: valid_session
      }.to change(Topic, :count).by(-1)
    end

    it "redirects to the topics list" do
      delete :destroy, params: {id: @topic.to_param}, session: valid_session
      expect(response).to redirect_to(topics_url)
    end
  end

end
