class Post < ApplicationRecord


######################ASSOCIATION#####################################################################################
	belongs_to :topic
	belongs_to :user
	has_many :comments, dependent: :destroy
	has_many :ratings, dependent: :destroy
	has_and_belongs_to_many :tags
	has_and_belongs_to_many :users , join_table: :posts_users_reads

	has_attached_file :image, styles: { large:"600x600>" ,medium: "300x300>", thumb: "100x100#" }
	# has_many :tag_post_members
	# has_many :tags ,through: :tag_post_members, dependent: :destroy



	accepts_nested_attributes_for :tags, reject_if: -> (tag) {tag['tag'].blank?}


 ################################validation######################################################################
	validates :title, presence: true , length:{ minimum: 3 , maximum: 25}
	validates :body, presence: true , length:{ minimum: 3 , maximum: 250}
	validates_attachment :image, content_type:{content_type: ["image/jpeg","image/png"] },
                       size: { in: 0..2.megabytes }

  ###########################SCOPE###########################################################################

	scope :topic_post, -> { order(title: :asc) }



end
