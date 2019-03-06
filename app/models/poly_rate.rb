class PolyRate < ApplicationRecord
################################ASSOCIATION######################################################################
  belongs_to :rateable, polymorphic: true
################################VALIDATION######################################################################
  validates :rating, numericality: { greater_than_or_equal_to: 0 , less_than_or_equal_to: 5,  only_integer: true }
  validates_uniqueness_of :user_id, scope: :rateable_id, rateable_type: 'Comment' , message: "already rated this comment"

################################SCOPE###########################################################################
  scope :by_type, -> (type) { where(rateable_type: type) }
  scope :post_average, -> { by_type("Post").average(:rating).truncate(1) }
  scope :comment_average, -> { by_type("Comment").average(:rating).truncate(1) }
end
