class CreateUserCommentRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :user_comment_ratings do |t|
      t.references :user, foreign_key: true
      t.references :comment, foreign_key: true
      t.integer :rating

      t.timestamps
    end
  end
end
