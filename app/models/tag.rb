class Tag < ApplicationRecord
	has_many :posts, through: :tag_post_member	
end
