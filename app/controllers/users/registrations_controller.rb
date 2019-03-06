# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super
  end

  # GET /resource/edit
  def edit
    super
    respond_to do |format|
      format.html
      format.js
    end
  end

  # PUT /resource
  def update
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    # required for settings form to submit when password is left blank
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    @user = User.find(current_user.id)

    resource = update_resource(@user, account_update_params)
    if resource
      # Sign in the user bypassing validation in case their password changed
      bypass_sign_in(@user)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  # DELETE /resource
  def destroy
    puts params[:user]
    @user = User.find_by_email(params[:user][:email])
    if @user.destroy_with_password(params[:user][:current_password])
      flash[:danger] = 'User was destroyed.'
      redirect_to new_user_session_path
    else
      flash[:notice] = 'Incorrect password'
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  private

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end

  # protected
  #
  # # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  # # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end
  # # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
  end

  # # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end
end
