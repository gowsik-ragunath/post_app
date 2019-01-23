class Post < ApplicationRecord


######################ASSOCIATION#####################################################################################
	belongs_to :topic
	has_many :comments, dependent: :destroy
	has_many :ratings, dependent: :destroy
	has_and_belongs_to_many :tags


	# has_many :tag_post_members
	# has_many :tags ,through: :tag_post_members, dependent: :destroy



	accepts_nested_attributes_for :tags, reject_if: -> (tag) {tag['tag'].blank?}


 ################################validation######################################################################
	validates :title, presence: true
	validates :body, presence: true


###########################SCOPE###########################################################################

	scope :topic_post, -> { order(title: :asc) }

	
end
