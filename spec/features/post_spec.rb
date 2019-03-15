require 'rails_helper'

RSpec.feature '#post' do
	before{
		@topic = create(:topic,name:'check topic')
		@tag = create(:tag,tag:'check')
		sign_in_auth
		Post.create!(title:'post1',body:'body of post1',topic_id:1,tag_ids:[1],user_id:@user.id)
		Post.create!(title:'post2',body:'body of post2',topic_id:1,tag_ids:[1],user_id:@user.id)
		visit('/')
		expect(page).to have_content('check topic')
		click_link('check topic')
		click_link("All Post")
	}

	feature 'post#new' do
		scenario 'list all the post' do
			click_link("New Post")
			fill_in('post_title', with:'post1')
			fill_in('post_body', with:'body of post1')
			select "check", from: 'post_tag_ids'
			click_button('submit')
			expect(current_path).to have_content('/topics/1/posts')
			expect(page).to have_content('Post was successfully created.')
			expect(page).to have_content('post1 (CHECK TOPIC)')
		end
	end

	feature 'post#new fail' do
		scenario 'post creation fails because of Body' do
			click_link("New Post")
			fill_in('post_title', with:'post1')
			fill_in('post_body', with:'')
			select "check", from: 'post_tag_ids'
			click_button('submit')
			expect(current_path).to have_content('/topics/1/posts')
		end

		scenario 'post creation fails because of Title and Body' do
			click_link("New Post")
			fill_in('post_title', with:'')
			fill_in('post_body', with:'')
			select "check", from: 'post_tag_ids'
			click_button('submit')
			expect(current_path).to have_content('/topics/1/posts')
		end
	end

	feature 'post#show' do
		scenario 'list all the post' do
			expect(current_path).to have_content('/topics/1/posts')
			expect(page).to have_content('post1 (CHECK TOPIC)')
			expect(page).to have_content('post2 (CHECK TOPIC)')
		end

		scenario 'show post1'  do
			visit('/topics/1/posts')
			expect(current_path).to have_content('/topics/1/posts')
			click_link('post1 (CHECK TOPIC)')
			expect(current_path).to have_content('/topics/1/posts/1')
			expect(page).to have_content('post1')
			expect(page).to have_content('Tags: check')
			expect(page).to have_content('body of post1')
		end

		scenario 'show post2' do
			visit('/topics/1/posts')
			expect(current_path).to have_content('/topics/1/posts')
			click_link('post2 (CHECK TOPIC)')
			expect(current_path).to have_content('/topics/1/posts/2')
			expect(page).to have_content('post2')
			expect(page).to have_content('Tags: check')
			expect(page).to have_content('body of post2')
		end
  end

	feature "posts#edit" do
		scenario 'edit posts2' do
			click_link('post2 (CHECK TOPIC)')
			expect(current_path).to have_content('/topics/1/posts/2')
			click_link('Edit')
			expect(current_path).to have_content('/topics/1/posts/2/edit')
			fill_in('post_title', with:'new_title')
			fill_in('post_body', with:'body of new_title')
			click_button('submit')
			expect(current_path).to have_content('/topics/1/posts/2')
      expect(page).to have_content('Post was successfully updated.')
			expect(page).to have_content('new_title')
			expect(page).to have_content('body of new_title')
		end

		scenario 'edit post with invalid field data' do
			click_link('post2 (CHECK TOPIC)')
			expect(current_path).to have_content('/topics/1/posts/2')
			click_link('Edit')
			expect(current_path).to have_content('/topics/1/posts/2/edit')
			fill_in('post_title', with:'')
			fill_in('post_body', with:'')
			click_button('submit')
			expect(page).to have_content("Title can't be blank, Title is too short (minimum is 3 characters)")
			expect(page).to have_content("Body can't be blank, Body is too short (minimum is 3 characters)")
		end
  end

	feature "posts#delete" do
		scenario 'delete posts2' do
			click_link('post2 (CHECK TOPIC)')
			expect(current_path).to have_content('/topics/1/posts/2')
			click_link('Delete')
			expect(current_path).to have_content('/topics/1/posts')
			expect(page).to have_content('Post was successfully destroyed.')
		end

		scenario 'delete post1' do
			click_link('post1 (CHECK TOPIC)')
			expect(current_path).to have_content('/topics/1/posts/1')
			click_link('Delete')
			expect(current_path).to have_content('/topics/1/posts')
			expect(page).to have_content('Post was successfully destroyed.')
		end
	end
end