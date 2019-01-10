require 'rails_helper'

RSpec.describe 'create new post' do
	

	describe 'add post'  do
		it 'visit new page' do
			visit('/')
			click_link('create')

			expect(current_path).to have_content('/new')
			fill_in('post_title', with: 'title1')
			fill_in('post_body', with: 'body of title')
			click_button('create')

			expect(current_path).to have_content('/')
			expect(page).to have_content('title1 body of title')
		end
	end

	describe 'invalid entry' do
		it 'visit new page with invalid data' do
			visit('/')
			click_link('create')

			expect(current_path).to have_content('/new')
			fill_in('post_title', with: 'title1')
			click_button('create')

			expect(current_path).to have_content('/')
			expect(page).to have_content('')
			
		end
	end


end