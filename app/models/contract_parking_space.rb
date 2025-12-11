class ContractParkingSpace < ApplicationRecord
  validates :contract_start_date, presence: true
  validates :contract_end_date, presence: true

  belongs_to :contractor
  belongs_to :parking_space
end
