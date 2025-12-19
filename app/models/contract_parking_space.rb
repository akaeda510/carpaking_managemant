class ContractParkingSpace < ApplicationRecord
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :contractor, presence: true
  validates :parking_space, presence: true, uniqueness: true
  validates :parking_manager, presence: true

  belongs_to :contractor
  belongs_to :parking_space
  belongs_to :parking_manager
end
