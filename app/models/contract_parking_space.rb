class ContractParkingSpace < ApplicationRecord
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :contractor, presence: true
  validates :parking_space, presence: true
  validates :parking_manager, presence: true

  belongs_to :contractor
  belongs_to :parking_space
  belongs_to :parking_manager

  has_one :parking_lot, through: :parking_space

  delegate :parking_area, to: :parking_space
  delegate :parking_lot, to: :parking_area

  # 有効な契約
  scope :active, -> {
    today = Date.current
    where("start_date <= :today AND (end_date >= :today OR end_date IS NULL)", today: today)
    }

  # 今月に新たに作成されたデータ
  scope :created_this_month, -> {
    where(created_at: Time.current.all_month)
  }

  # 終了した契約
  scope :terminated, -> {
    where("end_date < ?", Date.today)
  }

  # 終了日が今日以降、かつ30日以内か
  def expiring_soon?
    return false if end_date.blank? || end_date.to_s == "2999-12-31"
    end_date.between?(Date.today, Date.today + 30.days)
  end

  # 契約がすでに期間切れを確認
  def expired?
    end_date.present? && end_date < Date.today
  end

  def parking_area
    parking_space&.parking_area
  end
end
