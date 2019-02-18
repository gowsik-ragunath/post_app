class AddRatingToUserCommentRatings < ActiveRecord::Migration[5.2]
  def change
    add_reference :user_comment_ratings, :rating, foreign_key: true
  end
end
