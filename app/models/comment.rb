class Comment < ApplicationRecord


######################ASSOCIATION################################################################################
  belongs_to :post
	belongs_to :user
	has_many :user_comment_ratings
	has_many :users , through: :user_comment_ratings

 ################################validation######################################################################
	# validates :commenter, presence: true
	validates :body, presence: true

	scope :comment_order, -> { order(created_at: :desc) }
end
