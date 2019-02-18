class Rating < ApplicationRecord
################################ASSOCIATION######################################################################
  belongs_to :post, optional: true
  has_many :user_comment_ratings
  has_many :users , through: :user_comment_ratings , dependent: :destroy
  has_many :comments , through: :user_comment_ratings , dependent: :destroy

################################VALIDATION######################################################################
  validates :rating, numericality: { greater_than_or_equal_to: 0 , less_than_or_equal_to: 5,  only_integer: true }

################################SCOPE######################################################################
  scope :rating_average, -> { average(:rating).truncate(1) }
  scope :rating_order , -> { order(rating: :asc) }
end
