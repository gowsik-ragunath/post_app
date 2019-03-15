require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before{
    @user = User.create!(email:"email@email.com",password:"password",password_confirmation:"password",admin:true)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in @user
  }

  describe "GET #edit" do
    it "returns a success response" do
      get :edit
      expect(response).to render_template("edit")
      expect(response).to be_successful
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested user" do
        put :update, params: { user: { password: '1221312', password_confirmation: '1221312', current_password: 'password' } },format: :js
        expect(assigns(:user).updated_at).not_to eql(@user.updated_at)
        expect(response.body).to match('You are being <a href="http://test.host/users/sign_in">redirected</a>')
      end
    end
    context  "with invalid params" do
      it "wrong password in updating the requested user" do
        put :update, params: { user: { password: '1221312', password_confirmation: '1221312', current_password: 'passd' } },format: :js
        expect(assigns(:user).updated_at).not_to eql(@user.updated_at)
        expect(response.body).to match('Current password is invalid')
      end

      it "error retype password in updating the requested user" do
        put :update, params: { user: { password: '1221312', password_confirmation: '12212', current_password: 'password' } },format: :js
        expect(assigns(:user).updated_at).not_to eql(@user.updated_at)
        expect(response.body).to match('Password confirmation doesn&#39;t match Password')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user" do
      expect {
        delete :destroy
      }.to change(User, :count).by(-1)
    end
  end
end
