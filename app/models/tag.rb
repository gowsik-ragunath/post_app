class Tag < ApplicationRecord
################################ASSOCIATION######################################################################
	has_and_belongs_to_many :posts

################################VALIDATION######################################################################
	validates :tag, uniqueness: true , presence: true
end
