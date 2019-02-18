require 'rails_helper'

RSpec.describe TopicsController, type: :controller do
  before{
    @user = User.create!(email:"email@email.com",password:"password",password_confirmation:"password",admin:true)
    sign_in @user
    @topic = create(:topic)
    create(:topic ,name:'topic2')
    create(:topic ,name:'topic3')
    create(:topic ,name:'topic4')
    create(:topic ,name:'topic5')
  }

  describe "GET #index" do
    it "returns a success response" do
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe "GET #index json" do
    it "returns a json response page1" do
      get :index, params:{} , format: :json
      expect(response.status).to eql 200
      expect(json).to match([{"id"=>1, "name"=>"topic_name", "url"=>"http://test.host/topics/1.json"},
                                                {"id"=>2, "name"=>"topic2", "url"=>"http://test.host/topics/2.json"}])
    end

    it "returns a json response page2" do
      get :index  , params:{ page: 2 } , format: :json
      expect(response.status).to eql 200
      expect(json).to match([{"id"=>3, "name"=>"topic3", "url"=>"http://test.host/topics/3.json"},
                                                {"id"=>4, "name"=>"topic4", "url"=>"http://test.host/topics/4.json"}])
    end

    it "returns a json response page3" do
      get :index, params:{ page: 3 } , format: :json
      expect(response.status).to eql 200
      expect(json).to match([{"id"=>5, "name"=>"topic5", "url"=>"http://test.host/topics/5.json"}])
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: {id: @topic.to_param}
      expect(response).to be_successful
    end
  end

  describe "GET #show json" do
    it "returns a json response" do
      get :show, params: {id: @topic.to_param}, format: :json
      expect(response.status).to eql 200
      expect(json.keys).to contain_exactly('id', 'name', 'url')
      expect(json).to match("id"=>1, "name"=>"topic_name", "url"=>"http://test.host/topics/1.json")
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}
      expect(response.status).to eql 200
      expect(response).to render_template("new")
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: {id: @topic.to_param}
      expect(response).to render_template("edit")
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Topic" do
        expect {
          post :create, params: {topic: {name:"sddsa"} }
        }.to change(Topic, :count).by(1)
        expect(response).to redirect_to(topics_path)
        expect(flash[:notice]).to eq "Topic was successfully created."
      end

      it "creates a new Topic invalid param" do
        expect {
          post :create, params: {topic: {name:nil} }
        }.to change(Topic, :count).by(0)
        expect(response).to render_template("new")
        assigns(:topic).errors.empty?.should_not be true
      end

      it "redirects to the created topic" do
        post :create, params: {topic: {name:"DSa"}}
        expect(response).to redirect_to(topics_path)
        expect(flash[:notice]).to eq "Topic was successfully created."
      end
    end

    context "create json api call" do
      it "returns a json response" do
        post :create, params: {topic: {name:"new"}} , format: :json
        expect(response.status).to eql 200
        expect(json.keys).to contain_exactly('id','name')
        expect(json).to match({"id"=>Topic.last.id, "name"=>"new"})
      end

      it "returns a invalid json response" do
        post :create, params: {topic: {name:""}} , format: :json
        expect(response.status).to eql 422
        expect(json.keys).to contain_exactly('name')
        expect(json).to match("name" => ["can't be blank", "is too short (minimum is 3 characters)"])
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested topic" do
        put :update, params: {id: @topic.to_param, topic:{name:'update topic'}}
        expect(response).to redirect_to(topic_path)
        expect(flash[:notice]).to eq "Topic was successfully updated."
      end

      it "returns a json response" do
        put :update, params: {id: @topic.to_param, topic:{name:'update topic'}} , format: :json
        expect(response.status).to eql 200
        expect(json.keys).to contain_exactly('id','name','url')
        expect(json).to match({"id"=>1, "name"=>"update topic",
                                                  "url" => "http://test.host/topics/1.json"})
      end

      it "redirects to the topic" do
        put :update, params: {id: @topic.to_param, topic: {name:"valid_attributes"}}
        expect(response).to redirect_to(topic_path)
        expect(flash[:notice]).to eq "Topic was successfully updated."
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {id: @topic.to_param , topic: {name:nil}}
        expect(response).to render_template("edit")
        assigns(:topic).errors.empty?.should_not be true
      end

      it "returns a invalid json response" do
        put :update, params: {id: @topic.to_param, topic:{name:''}} , format: :json
        expect(response.status).to eql 422
        expect(json.keys).to contain_exactly('name')
        expect(json).to match("name" => ["can't be blank", "is too short (minimum is 3 characters)"])
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested topic" do
      expect {
        delete :destroy, params: {id: @topic.to_param}
      }.to change(Topic, :count).by(-1)
      expect(flash[:destroy]).to eq "Topic was successfully destroyed."
    end

    it "delete with a json response" do
      delete :destroy, params: {id: @topic.to_param} , format: :json
      expect(response.status).to eql 200
      expect(json.keys).to contain_exactly('message')
      expect(json).to match( {"message" => "record deleted"} )
    end

    it "redirects to the topics list" do
      delete :destroy, params: {id: @topic.to_param}
      expect(response).to redirect_to(topics_path)
      expect(flash[:destroy]).to eq "Topic was successfully destroyed."
    end
  end
end
