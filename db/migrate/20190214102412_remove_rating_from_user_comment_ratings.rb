class RemoveRatingFromUserCommentRatings < ActiveRecord::Migration[5.2]
  def change
    remove_column :user_comment_ratings, :rating, :integer
  end
end
