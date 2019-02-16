class Post < ApplicationRecord
################################ASSOCIATION######################################################################

	belongs_to :topic
	belongs_to :user
	has_many :poly_rates, as: :rateable #polymorphic association
	has_many :comments, dependent: :destroy
	has_many :ratings, dependent: :destroy #join table association
	has_and_belongs_to_many :tags
	has_and_belongs_to_many :users , join_table: :posts_users_reads
	has_attached_file :image, styles: { large:"600x600>" ,medium: "300x300>", thumb: "100x100#" }

################################NESTEDATTRIBUTES################################################################

	accepts_nested_attributes_for :tags, reject_if: -> (tag) {tag['tag'].blank?}

################################VALIDATION######################################################################

	validates :title, presence: true , length:{ minimum: 3 , maximum: 20}
	validates :body, presence: true , length:{ minimum: 3 , maximum: 250}
	validates_attachment :image, content_type:{content_type: ["image/jpeg","image/png"] },
											 size: { in: 0..2.megabytes }

################################SCOPE###########################################################################
	scope :post_order, -> { order(title: :asc) }
	scope :post_recent, -> { order(created_at: :desc) }
	scope :content_filter, -> (period_start, period_end) { where(created_at: period_start..period_end) }
end
