class ParkingLot < ApplicationRecord
  validates :name, presence: true, length: { maximum: 40 }
  validates :address, presence: true, length: { maximum: 140 }
  validates :desctiption, presence: true, length: { maximum: 65_535 }
  validates :total_spaces, presence: true, length: { in: 1..2 }, numericality: { only_integer: true }
  belongs_to :parking_manager
end
