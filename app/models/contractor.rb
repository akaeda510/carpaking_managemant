class Contractor < ApplicationRecord
  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  # 都道府県
  validates :prefecture, presence: true, length: { maximum: 10 }
  # 市区町村
  validates :city, presence: true, length: { maximum: 20 }
  # 丁目番地号
  validates :street_address, presence: true, length: { maximum: 50 }
  # マンション名、部屋番号等
  validates :building, length: { maximum: 55 }, allow_nil: true
  validates :phone_number, presence: true, length: { is: 11 }, numericality: { only_integer: true }, uniqueness: true
  validates :contact_number, length: { minimum: 10, maximum: 11 }, numericality: { only_integer: true }, allow_nil: true, allow_blank: true
  validates :notes, length: { maximum: 150 }

  has_many :contract_parking_spaces, dependent: :destroy
  has_many :active_cotractor_parking_space, -> { where('end_date >= ?', Date.current) }, class_name: 'ContractorParkingSpace'
  has_many :parking_spaces, through: :active_contractor_parking_spaces

  belongs_to :parking_manager
end
