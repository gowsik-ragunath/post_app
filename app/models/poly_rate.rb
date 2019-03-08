class PolyRate < ApplicationRecord
################################ENUM#############################################################################
  enum rating_as: { one: 1 ,two: 2 ,three: 3 ,four: 4 ,five: 5 }
################################ASSOCIATION######################################################################
  belongs_to :rateable, polymorphic: true
################################VALIDATION######################################################################
  # validates :rating, numericality: { greater_than_or_equal_to: 0 , less_than_or_equal_to: 5,  only_integer: true }
  validates_uniqueness_of :user_id, scope: [:rateable_id, :rateable_type] , message: "already rated"

################################SCOPE###########################################################################
  scope :by_type, -> (type) { where(rateable_type: type) }
  scope :post_average, -> { by_type("Post").average(:rating).truncate(1) }
  scope :comment_average, -> { by_type("Comment").average(:rating).truncate(1) }
  scope :rating_order , -> { order(rating: :asc) }
end
