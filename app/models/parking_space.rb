class ParkingSpace < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { maximum: 10 }
  validates :description, length: { maximum: 150 }
  validates :width, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9.9 }
  validates :length, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9.9 }
  validates :parking_lot, presence: true
  validates :parking_manager, presence: true

  has_many :contract_parking_spaces, dependent: :destroy
  has_many :active_contractor_parking_spaces, -> { where("end_date >= ?", Date.current) }, class_name: "ContractorParkingSpace"
  has_many :contractor, through: :active_contractor_parking_spaces

  belongs_to :parking_lot
  belongs_to :parking_manager

  # 駐車スペースの取得（すでに契約されているスペースは排除）
  scope :available, -> {
    # 現在有効な契約(契約済み) ParkingSpace のIDをサブクエリで取得
    occupied_ids = ContractParkingSpace.where("end_date >= ?", Date.current).select(:parking_space_id)
    # 上記の以外のID(契約していない) ParkingSpace のレコードを取得
    where.not(id: occupied_ids)
  }

  def current_contractor_id
    current_contractors_space&.contractor_id
  end
end
