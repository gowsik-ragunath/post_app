require 'rails_helper'

RSpec.describe "tag_post_members/show", type: :view do
  before(:each) do
    @tag_post_member = assign(:tag_post_member, TagPostMember.create!(
      :tag_id => 2,
      :post_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
