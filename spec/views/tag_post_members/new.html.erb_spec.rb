require 'rails_helper'

RSpec.describe "tag_post_members/new", type: :view do
  before(:each) do
    assign(:tag_post_member, TagPostMember.new(
      :tag_id => 1,
      :post_id => 1
    ))
  end

  it "renders new tag_post_member form" do
    render

    assert_select "form[action=?][method=?]", tag_post_members_path, "post" do

      assert_select "input[name=?]", "tag_post_member[tag_id]"

      assert_select "input[name=?]", "tag_post_member[post_id]"
    end
  end
end
