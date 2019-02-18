class Comment < ApplicationRecord
################################ASSOCIATION######################################################################
	belongs_to :post
	belongs_to :user
	has_many :user_comment_ratings
	has_many :users , through: :user_comment_ratings , dependent: :destroy
	has_many :ratings , through: :user_comment_ratings , dependent: :destroy

################################VALIDATION######################################################################
	validates :body, presence: true

################################SCOPE######################################################################
	scope :comment_order, -> { order(created_at: :desc) }
end
