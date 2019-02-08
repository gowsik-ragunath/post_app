class UserCommentRating < ApplicationRecord

######################ASSOCIATION################################################################################
  belongs_to :user
  belongs_to :comment

################################validation######################################################################
  validates :rating, numericality: { greater_than_or_equal_to: 0 , less_than_or_equal_to: 5,  only_integer: true }

end
