class ParkingArea < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  validates :default_price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :parking_lot, presence: true

  enum :category { asphalt: 0, gravel: 1, garage: 2 }

  belongs_to :parking_lot

  has_many :parking_spaces, dependent: :destroy

end
