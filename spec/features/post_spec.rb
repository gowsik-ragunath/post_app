require 'rails_helper'

RSpec.describe 'Post home' do
	describe 'viewing index' do
		it 'list all the post' do
			Post.create!(title:'post1', body:'abc')
			Post.create!(title:'post2', body:'123')

			visit('/')
			expect(page).to have_content('post1 abc')
			expect(page).to have_content('post2 123')
		end
	end
end