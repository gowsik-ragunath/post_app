require 'rails_helper'

RSpec.describe '#topics' do

  before{
		FactoryBot.create(:user, email: 'user@test.com', password: 'password123',password_confirmation:'password123',admin:true)
		visit new_user_session_path
		fill_in :user_email, with: 'user@test.com'
		fill_in :user_password, with: 'password123'
		click_on 'Log in'
  }

	describe 'topics#new success'  do
		it 'visit new topic page' do
			visit topics_path
			click_link('New Topic')

			expect(current_path).to have_content('/topics/new')
			fill_in('topic_name', with: 'rspec test topic')
			click_button('Create Topic')

			expect(current_path).to have_content('/topics')
			expect(page).to have_content('rspec test topic')
		end
	end


	describe 'topics#new fail'  do
		it 'visit new topic page' do
			visit('/')
			click_link('New Topic')

			expect(current_path).to have_content('/topics/new')
			fill_in('topic_name', with: '')
			click_button('Create Topic')
		end
	end

	describe 'topics#show'  do
		it 'show new topic' do
			visit('/')
			click_link('New Topic')

			expect(current_path).to have_content('/topics/new')
			fill_in('topic_name', with: 'news')
			click_button('Create Topic')
			
			expect(current_path).to have_content('/topics')
			expect(page).to have_content('news')
			
			click_link('news')
			expect(page).to have_content('Name: news')
			click_link('Back')

			expect(current_path).to have_content('/topics')
		end
	end


	describe 'topics#edit fail'  do
		it 'update topic' do
			visit('/')
			click_link('New Topic')

			expect(current_path).to have_content('/topics/new')
			fill_in('topic_name', with: '')
			click_button('Create Topic')
			
			expect(current_path).to have_content('/topics')

		end
	end


	describe 'topics#delete'  do
		it 'visit topic page' do
			visit('/')
			click_link('New Topic')

			expect(current_path).to have_content('/topics/new')
			fill_in('topic_name', with: 'news')
			click_button('Create Topic')
			
			expect(current_path).to have_content('/topics')
			expect(page).to have_content('news')
			
			click_link('Destroy')

			expect(page).to have_content('Topic was successfully destroyed.')
		end
	end

end