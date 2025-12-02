class ParkingSpace < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { maximum: 10 }
  validates :description, length: { maximum: 150 }
  validates :width, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9.99 }
  validates :length, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9.99 }

  enum parking_type: { asphalt: 0, gravel: 1, garage: 2 }

  belongs_to :parking_lot
  belongs_to :parking_manager
end
