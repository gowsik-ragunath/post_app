class Tag < ApplicationRecord


######################ASSOCIATION################################################################################
	# has_many :tag_post_members
	# has_many :posts, through: :tag_post_members, dependent: :destroy
	has_and_belongs_to_many :posts

 ################################validation######################################################################
	validates :tag, uniqueness: true , presence: true

end
