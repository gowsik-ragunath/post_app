class Post < ApplicationRecord
	belongs_to :topic
	has_many :comments
	has_many :tag_post_member
	has_many :tags , through: :tag_post_member
end
