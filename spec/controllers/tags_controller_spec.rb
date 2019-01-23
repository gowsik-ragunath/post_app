require 'rails_helper'


RSpec.describe TagsController, type: :controller do


  before{
    @tag = Tag.create!(tag:"new tag")
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
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: {id: @tag.to_param}, session: valid_session
      expect(response).to be_successful
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
      get :edit, params: {id: @tag.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Tag" do
        expect {
          post :create, params: {tag: {tag:"sd"} }, session: valid_session
        }.to change(Tag, :count).by(1)
      end

      it "redirects to the created tag" do
        post :create, params: {tag: {tag:"DSa"}} , session: valid_session
        expect(response).to redirect_to(tags_path)
      end
    end

  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested tag" do
        put :update, params: {id: @tag.to_param, tag:{tag:'update tag'}}, session: valid_session
        @tag.reload
      end

      it "redirects to the tag" do
        put :update, params: {id: @tag.to_param, tag: {tag:"valid_attributes"}}, session: valid_session
        expect(response).to redirect_to(@tag)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {id: @tag.to_param , tag: {tag:""}}, session: valid_session
        expect(response).to redirect_to(@tag)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested tag" do
      expect {
        delete :destroy, params: {id: @tag.to_param}, session: valid_session
      }.to change(Tag, :count).by(-1)
    end

    it "redirects to the tags list" do
      delete :destroy, params: {id: @tag.to_param}, session: valid_session
      expect(response).to redirect_to(tags_path)
    end
  end

end
