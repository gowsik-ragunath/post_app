class Rating < ApplicationRecord



######################ASSOCIATION################################################################################
  belongs_to :post


################################validation######################################################################
  validates :rating, numericality: { less_than_or_equal_to: 5,  only_integer: true }
end
