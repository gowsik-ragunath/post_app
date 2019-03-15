class Comment < ApplicationRecord
################################ASSOCIATION######################################################################
	belongs_to :post
	belongs_to :user
  has_many :poly_rates, as: :rateable #polymorphic association
	has_many :user_comment_ratings
	has_many :users , through: :user_comment_ratings , dependent: :destroy
	has_many :ratings , through: :user_comment_ratings , dependent: :destroy #join table association

################################VALIDATION######################################################################
	validates :body, presence: true

################################SCOPE###########################################################################
	scope :comment_order, -> { order(created_at: :desc) }
end
