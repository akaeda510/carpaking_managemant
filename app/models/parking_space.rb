class ParkingSpace < ApplicationRecord
  after_initialize :set_default_values, if: new_record?

  validates :name, presence: true, uniqueness: { scope: :parking_lot_id, message: "はこの駐車場内ですでに使用されています" }, length: { maximum: 10 }
  validates :description, length: { maximum: 150 }
  validates :width, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9.9 }
  validates :length, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9.9 }
  validates :parking_lot, presence: true
  validates :parking_manager, presence: true

  has_many :contract_parking_spaces
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

  private

  def set_default_values
    self.width ||= 0.0
    self.length ||= 0.0
  end
end
