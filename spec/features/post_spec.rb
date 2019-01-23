require 'rails_helper'

RSpec.describe '#post' do

	before{
		Topic.create!(name:'check topic')
		Tag.create!(tag:'check')
	}


	describe 'post#new' do
		it 'list all the post' do
			
			visit('/')
			expect(page).to have_content('check topic')

			click_link('check topic')
			expect(page).to have_content('Name: check topic')
			click_link("New Post")

			expect(current_path).to have_content('/topics/1/posts/new')
			fill_in('post_title', with:'post1')
			fill_in('post_body', with:'body of post1')
			select "check", from: 'post_tag_ids'
			click_button('submit')

			expect(current_path).to have_content('/topics/1/posts')
			expect(page).to have_content('Post was successfully created.')
			expect(page).to have_content('post1 (CHECK TOPIC)')

		end
	end


	describe 'post#new fail' do

		it 'post creation fails because of Body' do
			
			visit('/')
			expect(page).to have_content('check topic')

			click_link('check topic')
			expect(page).to have_content('Name: check topic')
			click_link("New Post")

			expect(current_path).to have_content('/topics/1/posts/new')
			fill_in('post_title', with:'post1')
			fill_in('post_body', with:'')
			select "check", from: 'post_tag_ids'
			click_button('submit')

			expect(current_path).to have_content('/topics/1/posts')

		end

		it 'post creation fails because of Title and Body' do
			
			visit('/')
			expect(page).to have_content('check topic')

			click_link('check topic')
			expect(page).to have_content('Name: check topic')
			click_link("New Post")

			expect(current_path).to have_content('/topics/1/posts/new')
			fill_in('post_title', with:'')
			fill_in('post_body', with:'')
			select "check", from: 'post_tag_ids'
			click_button('submit')

			expect(current_path).to have_content('/topics/1/posts')

		end
	end



	describe 'post#show' do
		before{
			Post.create!(title:'post1',body:'body of post1',topic_id:1,tag_ids:[1])
			Post.create!(title:'post2',body:'body of post2',topic_id:1,tag_ids:[1])
		}


		it 'list all the post' do
			
			visit('/')
			expect(page).to have_content('check topic')

			click_link('check topic')
			expect(page).to have_content('Name: check topic')

			click_link('All Posts')
			expect(current_path).to have_content('/topics/1/posts')
			expect(page).to have_content('post1 (CHECK TOPIC)')
			expect(page).to have_content('post2 (CHECK TOPIC)')
		

		end

		it 'show post1' do

			visit('/topics/1/posts')
			expect(current_path).to have_content('/topics/1/posts')
			click_link('post1 (CHECK TOPIC)')

			expect(current_path).to have_content('/topics/1/posts/1')
			expect(page).to have_content('post1')
			expect(page).to have_content('Tags: check')
			expect(page).to have_content('body of post1')

		end

		it 'show post2' do

			visit('/topics/1/posts')
			expect(current_path).to have_content('/topics/1/posts')
			
			click_link('post2 (CHECK TOPIC)')

			expect(current_path).to have_content('/topics/1/posts/2')
			expect(page).to have_content('post2')
			expect(page).to have_content('Tags: check')
			expect(page).to have_content('body of post2')

		end

	end

	describe "posts#delete" do

		before{
			Post.create!(title:'post1',body:'body of post1',topic_id:1,tag_ids:[1])
			Post.create!(title:'post2',body:'body of post2',topic_id:1,tag_ids:[1])
			
			visit('/')
			expect(page).to have_content('check topic')

			click_link('check topic')
			expect(page).to have_content('Name: check topic')

			click_link('All Posts')
			expect(current_path).to have_content('/topics/1/posts')

		}

		it 'delete posts2' do
			
			click_link('post2 (CHECK TOPIC)')
			expect(current_path).to have_content('/topics/1/posts/2')
			click_link('Delete')

			expect(current_path).to have_content('/topics/1/posts')
			expect(page).to have_content('Post was successfully destroyed.')
		
		end

		it 'delete post1' do			
			
			click_link('post1 (CHECK TOPIC)')
			expect(current_path).to have_content('/topics/1/posts/1')
			click_link('Delete')

			expect(current_path).to have_content('/topics/1/posts')
			expect(page).to have_content('Post was successfully destroyed.')

		end
	end

end