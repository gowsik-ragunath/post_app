class Comment < ApplicationRecord


######################ASSOCIATION################################################################################
  belongs_to :post
	belongs_to :user

 ################################validation######################################################################
	# validates :commenter, presence: true
	validates :body, presence: true
end
