class Comment < ApplicationRecord


######################ASSOCIATION################################################################################
  belongs_to :post

 ################################validation######################################################################
	validates :commenter, presence: true
	validates :body, presence: true
  	validates :post_id, presence: true
end
