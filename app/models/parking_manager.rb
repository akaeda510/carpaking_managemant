class ParkingManager < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search_full_text,
    against: {
      first_name: "A",
      last_name: "A",
      phone_number: "B",
      contact_number: "B",
      prefecture: "C",
      city: "C",
      street_address: "C"
    },
    using: {
      tsearch: {
        prefix: true,
        dictionary: "simple"
      },
      trigram: {}
    }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 50 }
  # 都道府県
  validates :prefecture, presence: true, inclusion: {
    in: ->(_) { I18n.t("prefectures").values },
    message: "を正しく選択してください" }
  # 市区町村
  validates :city, presence: true, length: { maximum: 20 }
  # 丁目番地号
  validates :street_address, presence: true, length: { maximum: 50 }
  # マンション名、部屋番号等
  validates :building, length: { maximum: 55 }, allow_nil: true
  validates :phone_number, presence: true, length: { is: 11 }, numericality: { only_integer: true }, uniqueness: true
  validates :contact_number, length: { minimum: 10, maximum: 11 }, numericality: { only_integer: true }, allow_nil: true, allow_blank: true
  # 利用規約
  validates :terms_of_service, acceptance: { message: "に同意してください" }, on: :create

  attr_accessor :tel1, :tel2, :tel3

  before_validation :set_phone_number

  # 駐車場区画
  has_many :parking_lots, dependent: :destroy
  # 駐車スペース
  has_many :parking_areas, through: :parking_lots
  has_many :parking_spaces, through: :parking_areas
  has_many :contract_parking_spaces, through: :parking_lots
  # 契約者
  has_many :contractors, -> { distinct }
  has_many :active_contract_parking_spaces,
           -> { where("end_date >= ?", Date.current) },
           through: :parking_spaces,
           source: :contract_parking_spaces
  has_many :devices, dependent: :destroy

  def set_initial_device(user_agent, ip_address)
    devices.create!(
      device_token: Device.generate_token,
      user_agent: user_agent,
      name: "初期登録デバイス",
      expires_at: 1.month.from_now,
      is_verified: true
    )
  rescue => e
    Rails.logger.error "Device creation failed: #{e.message}"
    raise e
  end

  private

  def set_phone_number
    if [ tel1, tel2, tel3 ].all?(&:present?)
      self.phone_number = "#{tel1}#{tel2}#{tel3}"
    end
  end
end
