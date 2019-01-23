class TagPostMember < ApplicationRecord


######################ASSOCIATION################################################################################
	belongs_to :post
	belongs_to :tag
end
