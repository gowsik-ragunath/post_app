# require 'rails_helper'
#
# RSpec.feature '#topics' do
#   before{
#     sign_in_auth(true)
#     visit('/')
#     click_link('New Topic')
#     expect(current_path).to have_content('/topics/new')
#     fill_in('topic_name', with: 'rspec test topic')
#     click_button('Create Topic')
#     expect(current_path).to have_content('/topics')
#   }
#
#   feature 'topics#new success' do
#     before{
#       click_link('Edit profile')
#     }
#     scenario 'visit new topic page',:js do
#       fill_in('user_password', with: '12345')
#       fill_in('user_password_confirmation', with: '12345')
#       fill_in('user_current_password', with: 'passsword')
#       click_button('Update')
#     end
#   end
# end