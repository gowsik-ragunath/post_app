require 'rails_helper'

RSpec.describe "tag_post_members/edit", type: :view do
  before(:each) do
    @tag_post_member = assign(:tag_post_member, TagPostMember.create!(
      :tag_id => 1,
      :post_id => 1
    ))
  end

  it "renders the edit tag_post_member form" do
    render

    assert_select "form[action=?][method=?]", tag_post_member_path(@tag_post_member), "post" do

      assert_select "input[name=?]", "tag_post_member[tag_id]"

      assert_select "input[name=?]", "tag_post_member[post_id]"
    end
  end
end
