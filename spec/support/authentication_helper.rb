module AuthenticationHelper
  def sign_in_auth(val = false)
    visit new_user_session_path
    @user = create(:user,admin: val)
    fill_in :user_email, with: 'user@test.com'
    fill_in :user_password, with: 'password'
    click_on 'Log in'
    return @user
  end
end