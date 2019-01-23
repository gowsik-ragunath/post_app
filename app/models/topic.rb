class Topic < ApplicationRecord



######################ASSOCIATION################################################################################
	has_many :posts, dependent: :destroy



 ################################validation######################################################################
	validates :name, presence: true
end
