require 'rails_helper'

RSpec.feature '#rating' do
  before{
    @topic = create(:topic,name:'check topic')
    @tag = create(:tag,tag:'check')
    sign_in_auth
    @post = create(:post, title: 'post1', body: 'body of post1' , user_id: @user.id,topic_id:@topic.id)
    visit('/')
    expect(page).to have_content('check topic')
    click_link('check topic')
    click_link("All Post")
    expect(page).to have_content('post1 (CHECK TOPIC)')
    click_link("post1 (CHECK TOPIC)")
  }

  feature 'post#rate' do
    scenario 'should create new comment' do
      within('#rating-form') do
        choose "rating_4"
        click_button "save"
      end
      expect(page).to have_content('Post rated successfully.')
    end
  end
end