require 'rails_helper'

RSpec.feature '#comment' do
  before{
    @topic = create(:topic,name:'check topic')
    @tag = create(:tag,tag:'check')
    sign_in_auth
    @post = create(:post, title: 'post1', body: 'body of post1' , user_id: @user.id,topic_id:@topic.id)
    visit('/')
    expect(page).to have_content('check topic')
    click_link('check topic')
    expect(page).to have_content('check topic')
    click_link("All Post")
    expect(page).to have_content('post1 (CHECK TOPIC)')
    click_link("post1 (CHECK TOPIC)")
  }

  feature 'comment#new' do
    scenario 'should create new comment' do
      fill_in  :comment_body, with: 'new comment for post1'
      click_on 'Create Comment'
      expect(page).to have_content('Comment was successfully created.')
    end
  end

  feature 'comment#edit' do
    scenario 'should create rating for the comment' do
      fill_in  :comment_body, with: 'new comment for post1'
      click_on 'Create Comment'
      expect(page).to have_content('Comment was successfully created.')
      within "table" do
        click_link "edit"
      end
      expect(page).to have_content('Editing Comment')
    end
  end

  feature 'comment#rate_comment' do
    scenario 'should create rating for the comment' do
      fill_in  :comment_body, with: 'new comment for post1'
      click_on 'Create Comment'
      expect(page).to have_content('Comment was successfully created.')
      within "table" do
        choose "rating_4"
        click_button("Save")
      end
    end
  end

  # feature 'comment#show_comment',js: true do
  #   before{
  #     fill_in  :comment_body, with: 'new comment for post1'
  #     click_on 'Create Comment'
  #     expect(page).to have_content('Comment was successfully created.')
  #     within "table" do
  #       choose "rating_4"
  #       click_button("Save")
  #     end
  #   }
  #   scenario 'should show rating for the comment' do
  #     within "table" do
  #       click_on 'Comment Ratings'
  #       # page.execute_script("document.querySelector('Comment Ratings').click()")
  #       # wnd = window_opened_by { click_on 'Comment Ratings' }
  #       # puts wnd
  #     end
  #
  #     # page.evaluate_script("window.location.reload()")
  #     # within "#modal-window" do
  #     #   expect(page).to have_content("Email sent")
  #     # end
  #   end
  # end

  feature 'comment#delete' do
    scenario 'should create rating for the comment' do
      fill_in  :comment_body, with: 'new comment for post1'
      click_on 'Create Comment'
      expect(page).to have_content('Comment was successfully created.')
      within "table" do
        click_link "delete"
      end
      expect(page).to have_content('Comment was successfully destroyed.')
    end
  end
end