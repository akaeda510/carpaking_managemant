class GarageDetail < ApplicationRecord
  validates :height, numericality: { greater_than_or_equal_to: 0,     less_than_or_equal_to: 99.9 }

  belongs_to :parking_space
end
