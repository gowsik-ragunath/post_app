class Topic < ApplicationRecord



######################ASSOCIATION################################################################################
	has_many :posts, dependent: :destroy



 ################################validation######################################################################
	validates :name, presence: true, length:{ minimum: 3 , maximum: 25}
end
