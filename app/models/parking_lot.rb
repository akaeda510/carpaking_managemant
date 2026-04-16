class ParkingLot < ApplicationRecord
  validates :name, presence: true, length: { maximum: 40 }
  validates :prefecture, inclusion: {
    in: ->(_) { I18n.t("prefectures").values },
    message: "を正しく選択してください" }
  validates :city, presence: true, length: { maximum: 20 }
  validates :street_address, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 150 }
  validates :total_spaces, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 99 }
  validates :parking_manager, presence: true

  belongs_to :parking_manager

  has_many :parking_areas, dependent: :destroy
  has_many :parking_spaces, through: :parking_areas
  has_many :contract_parking_spaces, through: :parking_spaces

  def address
    "#{prefecture} #{city} #{street_address}"
  end

  # 指定したIDを検索
  def self.find_by_id_or_first(id)
    id.present? ? find_by(id: id) : first
  end

  def dashboard_status
    total = parking_spaces.count
    contracted = parking_spaces.contracted.count

    {
      contractes_count: contracted,
      available: parking_spaces.available.count,
      total_capacity: total,
      occupancy_rate: total.positive? ? (contracted.to_f / total * 100).round(1) :0,
      monthly_revenue: parking_spaces.contracted.sum(:price),
      active_tenants_count: contract_parking_spaces.active.count
    }
  end
end
