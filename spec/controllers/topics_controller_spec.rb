require 'rails_helper'

RSpec.describe TopicsController, type: :controller do

  before{
    @user = User.create!(email:"email@email.com",password:"password",password_confirmation:"password",admin:true)
    sign_in @user
  }

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
    it "returns a success response" do
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #index json" do
    before do
      Topic.create!({ name:'topic2' })
      Topic.create!({ name:'topic3' })
      Topic.create!({ name:'topic4' })
      Topic.create!({ name:'topic5' })
    end

    it "returns a json response page1" do
      get :index, params:{} , format: :json
      expect(JSON.parse(response.body)).to eql([{"id"=>1, "name"=>"topic", "url"=>"http://test.host/topics/1.json"},{"id"=>2, "name"=>"topic2", "url"=>"http://test.host/topics/2.json"}])
    end

    it "returns a json response page2" do
      get :index  , params:{ page: 2 } , format: :json
      expect(JSON.parse(response.body)).to eql([{"id"=>3, "name"=>"topic3", "url"=>"http://test.host/topics/3.json"},{"id"=>4, "name"=>"topic4", "url"=>"http://test.host/topics/4.json"}])
    end

    it "returns a json response page3" do
      get :index, params:{ page: 3} , format: :json
      expect(JSON.parse(response.body)).to eql([{"id"=>5, "name"=>"topic5", "url"=>"http://test.host/topics/5.json"}])
    end
  end

  describe "GET #show" do
    login_user
    it "returns a success response" do
      get :show, params: {id: @topic.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show json" do
    it "returns a json response" do
      get :show, params: {id: @topic.to_param}, format: :json
      expect(JSON.parse(response.body)).to eql("id"=>1, "name"=>"topic", "url"=>"http://test.host/topics/1.json")
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: {id: @topic.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Topic" do
        expect {
          post :create, params: {topic: {name:"sddsa"} }, session: valid_session
        }.to change(Topic, :count).by(1)
        expect(response).to redirect_to(topics_path)
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

    context "create json api call" do
      it "returns a json response" do
        post :create, params: {topic: {name:"new"}} , format: :json
        expect(JSON.parse(response.body)).to eql({"id"=>2, "name"=>"new"})
      end

      it "returns a invalid json response" do
        post :create, params: {topic: {name:""}} , format: :json
        expect(JSON.parse(response.body)).to eql("name" => ["can't be blank", "is too short (minimum is 3 characters)"])
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested topic" do
        put :update, params: {id: @topic.to_param, topic:{name:'update topic'}}, session: valid_session
        @topic.reload
      end

      it "redirects to the topic" do
        put :update, params: {id: @topic.to_param, topic: {name:"valid_attributes"}}, session: valid_session
        expect(response).to redirect_to(topic_path)
      end
    end

    context "update json api call" do
      it "returns a json response" do
        put :update, params: {id: @topic.to_param, topic:{name:'update topic'}} , format: :json
        expect(JSON.parse(response.body)).to eql({"id"=>1, "name"=>"update topic","url" => "http://test.host/topics/1.json"})
      end

      it "returns a invalid json response" do
        put :update, params: {id: @topic.to_param, topic:{name:''}} , format: :json
        expect(JSON.parse(response.body)).to eql("name" => ["can't be blank", "is too short (minimum is 3 characters)"])
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
    it "destroys the requested topic" do
      expect {
        delete :destroy, params: {id: @topic.to_param}, session: valid_session
      }.to change(Topic, :count).by(-1)
    end

    it "delete with a json response" do
      delete :destroy, params: {id: @topic.to_param} , format: :json
      expect(JSON.parse(response.body)).to eql( {"message" => "record deleted"} )
    end

    it "redirects to the topics list" do
      delete :destroy, params: {id: @topic.to_param}, session: valid_session
      expect(response).to redirect_to(topics_path)
    end
  end

end
