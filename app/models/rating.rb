class Rating < ApplicationRecord



######################ASSOCIATION################################################################################
  belongs_to :post


################################validation######################################################################
  validates :rating, numericality: { greater_than_or_equal_to: 0 , less_than_or_equal_to: 5,  only_integer: true }

  scope :rating_average, -> { average(:rating).truncate(1) }
  scope :rating_order , -> { order(rating: :asc) }

end
