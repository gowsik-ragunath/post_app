require 'rails_helper'

RSpec.describe "tag_post_members/index", type: :view do
  before(:each) do
    assign(:tag_post_members, [
      TagPostMember.create!(
        :tag_id => 2,
        :post_id => 3
      ),
      TagPostMember.create!(
        :tag_id => 2,
        :post_id => 3
      )
    ])
  end

  it "renders a list of tag_post_members" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
