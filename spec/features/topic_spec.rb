require 'rails_helper'

RSpec.feature '#topics' do
	before{
		sign_in_auth(true)
		visit('/')
		click_link('New Topic')
		expect(current_path).to have_content('/topics/new')
	}

	feature 'topics#new success'  do
		scenario 'visit new topic page' do
			fill_in('topic_name', with: 'rspec test topic')
			click_button('Create Topic')
			expect(current_path).to have_content('/topics')
			expect(page).to have_content('Topic was successfully created.')
			expect(page).to have_content('rspec test topic')
		end
	end

	feature 'topics#new fail'  do
		scenario 'visit new topic page' do
			fill_in('topic_name', with: '')
			click_button('Create Topic')
			expect(page).to have_content("can't be blank, is too short (minimum is 3 characters)")
    end

		scenario 'visit new topic page' do
			fill_in('topic_name', with: 'abcdefghijklmnopqurstuvwxyz')
			click_button('Create Topic')
			expect(page).to have_content("is too long (maximum is 25 characters)")
		end
	end

	feature 'topics#show'  do
		scenario 'show new topic' do
			fill_in('topic_name', with: 'news')
			click_button('Create Topic')
			expect(current_path).to have_content('/topics')
			expect(page).to have_content('news')
			click_link('news')
			expect(page).to have_content('news')
			click_link('Back')
			expect(current_path).to have_content('/topics')
		end
	end

	feature 'topics#edit fail'  do
		scenario 'update topic' do
			fill_in('topic_name', with: '')
			click_button('Create Topic')
			expect(current_path).to have_content('/topics')
		end
	end

	feature 'topics#delete'  do
		scenario 'visit topic page' do
			fill_in('topic_name', with: 'news')
			click_button('Create Topic')
			expect(current_path).to have_content('/topics')
			expect(page).to have_content('news')
			click_link('Destroy')
			expect(page).to have_content('Topic was successfully destroyed.')
		end
	end
end