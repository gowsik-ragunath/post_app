class UserCommentRating < ApplicationRecord
################################ASSOCIATION######################################################################
  belongs_to :user
  belongs_to :comment
  belongs_to :rating

################################VALIDATION#######################################################################
  validates_uniqueness_of :user_id, scope: :comment_id, message: "already rated the comment"
end
