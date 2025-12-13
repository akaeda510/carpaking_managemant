class ParkingSpace < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { maximum: 10 }
  validates :description, length: { maximum: 150 }
  validates :width, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9.9 }
  validates :length, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9.9 }

  has_many :contract_parking_spaces, dependent: :destroy
  has_many :active_contractor_parking_spaces, -> { where('end_date >= ?', Date.current) }, class_name: 'ContractorParkingSpace'
  has_many :contractor, through: :active_contractor_parking_spaces

  belongs_to :parking_lot
  belongs_to :parking_manager
end
