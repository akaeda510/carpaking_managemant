class ContractParkingSpace < ApplicationRecord
  validates :start_date, presence: true
  validates :end_date, presence: true

  belongs_to :contractor
  belongs_to :parking_space
  belongs_to :parking_manager
end
