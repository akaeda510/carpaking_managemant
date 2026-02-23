class ParkingSpace < ApplicationRecord
  after_initialize :set_default_values

  validates :name, presence: true, uniqueness: { scope: :parking_lot_id, message: "はこの駐車場内ですでに使用されています" }, length: { maximum: 10 }
  validates :description, length: { maximum: 150 }
  validates :width, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9.9 }
  validates :length, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9.9 }
  validates :parking_lot, presence: true
  validates :parking_manager, presence: true
  
  validate :name_id_immutable_if_contracted, on: :update

  enum :parking_type, { asphalt: 0, gravel: 1, garage: 2 }
  enum :status, { available: 0, contracted: 1, pending: 2, prohibited: 3 }
  # 駐車スペースの契約状態スペースを消そうとする時に、契約データがあった場合、エラーで処理を阻止
  has_many :contract_parking_spaces, dependent: :restrict_with_exception
  has_many :active_contractor_parking_spaces, -> { where("end_date >= ?", Date.current) }, class_name: "ContractorParkingSpace"
  has_many :contractor, through: :contractor_parking_spaces

  has_many :parking_space_option_assignments, dependent: :destroy
  has_many :parking_space_options, through: :parking_space_option_assignments

  has_one :garage_detail, dependent: :destroy
  accepts_nested_attributes_for :garage_detail, reject_if: :not_a_garage?, allow_destroy: :true

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

  # ガレージを選択したか確認
  def not_a_garage?(attributes)
    parking_type != "garage"
  end

  # 契約終了日が今日以降、または無期限の契約か確認
  def currently_contracted?
    contract_parking_spaces.where("end_date >= ?", Date.today).exists?
  end

  private

  def set_default_values
    if new_record?
      self.width ||= 0.0
      self.length ||= 0.0
    end
  end

  def name_id_immutable_if_contracted
    if name_changed? && contract_parking_spaces.exists?
      errors.add(:name, "は契約実績があるため変更できません。")
    end
  end
end
