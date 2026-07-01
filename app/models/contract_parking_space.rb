class ContractParkingSpace < ApplicationRecord
  before_validation :undetermined

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

  after_save :sync_parking_space_status

  after_destroy :sync_parking_space_status

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

  private

  # 契約状況によってparking_space.statusを同期
  def sync_parking_space_status
    return if parking_space.status_prohibited?

    new_status =
      if parking_space.contract_parking_spaces.active.exists?
        :contracted
      else
        :available
      end
    parking_space.update!(status: new_status) unless parking_space.status == new_status.to_s
  end

  def undetermined
    if end_date.present? && end_date.to_s != '2999-12-31'
      self.end_date_undetermined = false
    elsif end_date_undetermined?
      end_date.present?
      self.end_date_undetermined = '2999-12-31'
    end
  end
end
