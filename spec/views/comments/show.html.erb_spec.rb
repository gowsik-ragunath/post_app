require 'rails_helper'

RSpec.describe "comments/show", type: :view do
  before(:each) do
    @comment = assign(:comment, Comment.create!(
      :commenter => "Commenter",
      :body => "MyText",
      :posts => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Commenter/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
