class Users::RegistrationsController < Devise::RegistrationsController
  # PUT /resource
  def update
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    @user = User.find(current_user.id)

    resource = update_resource(@user, account_update_params)
    if resource
      sign_out @user
      respond_to do |format|
        format.html { redirect_to  new_user_session_path , notice: 'Your account has been updated successfully.' }
        format.js { redirect_to new_user_session_path  , notice: 'Your account has been updated successfully.'}
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js
      end
    end
  end

  private

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end
end
