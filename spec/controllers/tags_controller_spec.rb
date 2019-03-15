require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  before{
    @user = create(:user,email:"email@email.com",password:"password")
    @tag = create(:tag)
    sign_in @user
  }

  describe "GET #index" do
    it "returns a success response" do
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: {id: @tag.to_param}
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}
      expect(response).to render_template("new")
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: {id: @tag.to_param}
      expect(response).to render_template("edit")
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Tag" do
        expect {
          post :create, params: {tag: {tag:"sd"} }
        }.to change(Tag, :count).by(1)
        expect(flash[:success]).to eq "Tag was successfully created."
      end

      it "creates a new Tag with invalid params" do
        expect {
          post :create, params: { tag:{tag: nil }}
        }.to change(Tag, :count).by(0)
        expect(response).to render_template("new")
        assigns(:tag).errors.empty?.should_not be true
      end

      it "redirects to the created tag" do
        post :create, params: {tag: {tag:"DSa"}}
        expect(response).to redirect_to(tags_path)
        expect(flash[:success]).to eq "Tag was successfully created."
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested tag" do
        put :update, params: {id: @tag.to_param, tag:{tag:'update tag'}}
        expect(response).to redirect_to(tag_path)
      end

      it "updates the requested tag with invalid params" do
        put :update, params: {id: @tag.to_param, tag:{tag:nil}}
        expect(response).to render_template("edit")
        assigns(:tag).errors.empty?.should_not be true
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {id: @tag.to_param , tag: {tag:""}}
        expect(response).to render_template("edit")
        assigns(:tag).errors.empty?.should_not be true
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested tag" do
      expect {
        delete :destroy, params: {id: @tag.to_param}
      }.to change(Tag, :count).by(-1)
      expect(flash[:destroy]).to eq "Tag was successfully destroyed."
    end

    it "redirects to the tags list" do
      delete :destroy, params: {id: @tag.to_param}
      expect(response).to redirect_to(tags_path)
      expect(flash[:destroy]).to eq "Tag was successfully destroyed."
    end
  end
end
