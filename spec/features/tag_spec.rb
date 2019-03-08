require 'rails_helper'

RSpec.feature '#tags' do
  before{
    sign_in_auth(true)
    visit tags_path
    click_link('New Tag')
  }

  feature 'tag#new success', js:true do
    scenario 'visit new tag page', driver: :rack_test do
      fill_in :tag_tag, with: 'new_tag'
      click_button('submit')
      expect(page).to have_content('Tag was successfully created.')
    end
  end

  feature 'tag#new fail'  do
    scenario 'visit new tag page' do
      fill_in :tag_tag, with: ''
      click_button('submit')
      expect(page).to have_content('error prohibited this action from being saved')
    end
  end

  feature 'tags#show'  do
    scenario 'show new tag' do
      fill_in :tag_tag, with: 'new_tag'
      click_button('submit')
      expect(page).to have_content('Tag was successfully created.')
      within 'table' do
        click_link("Show")
      end
      expect(page).to have_content('Tag: new_tag')
    end
  end

  feature 'tags#edit'  do
    scenario 'update tag' do
      fill_in :tag_tag, with: 'new_tag'
      click_button('submit')
      expect(page).to have_content('Tag was successfully created.')
      within 'table' do
        click_link("Edit")
      end
      expect(page).to have_content("Editing Tag")
      expect(page).to have_selector("input[value='new_tag']")
    end
  end

  feature 'tags#edit fail'  do
    scenario 'update tag' do
      fill_in :tag_tag, with: 'new_tag'
      click_button('submit')
      expect(page).to have_content('Tag was successfully created.')
      within 'table' do
        click_link("Edit")
      end
      expect(page).to have_content("Editing Tag")
      expect(page).to have_selector("input[value='new_tag']")
      fill_in :tag_tag, with:''
      click_button("submit")
      expect(page).to have_content('error prohibited this action from being saved')
    end
  end

  feature 'topics#delete'  do
    scenario 'visit topic page' do
      fill_in :tag_tag, with: 'new_tag'
      click_button('submit')
      expect(page).to have_content('Tag was successfully created.')
      within 'table' do
        click_link('Destroy')
      end
      expect(page).to have_content('Tag was successfully destroyed.')
    end
  end
end