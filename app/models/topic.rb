class Topic < ApplicationRecord
################################ASSOCIATION######################################################################
	has_many :posts, dependent: :destroy

################################VALIDATION######################################################################
	validates :name, presence: true, length:{ minimum: 3 , maximum: 25}
end
