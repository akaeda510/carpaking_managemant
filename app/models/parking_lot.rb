class ParkingLot < ApplicationRecord
  validates :name, presence: true, length: { maximum: 40 }
  validates :prefecture, presence: true, length: { maximum: 10 }
  validates :city, presence: true, length: { maximum: 20 }
  validates :street_address, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 150 }
  validates :total_spaces, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 99 }

  belongs_to :parking_manager

  has_many :parking_spaces, dependent: :destroy
end
