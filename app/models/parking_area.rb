class ParkingArea < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }, uniqueness: { scope: :parking_lot_id, message: "はすでに駐車場内で使用されています" }
  validates :default_price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :parking_lot, presence: true

  enum :category, { asphalt: 0, gravel: 1, garage: 2, others: 99 }, prefix: true

  belongs_to :parking_lot

  has_many :parking_spaces, dependent: :destroy

end
