class ParkingManager < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 50 }
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

  # 駐車場区画
  has_many :parking_lots, dependent: :destroy
  # 駐車スペース
  has_many :parking_spaces, dependent: :destroy
  # 契約者
  has_many :contractor, dependent: :destroy
  # 契約者の駐車スペース
  has_many :contract_parking_space, dependent: :destroy
end
