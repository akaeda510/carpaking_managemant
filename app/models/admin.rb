class Admin < ApplicationRecord
  has_secure_password

  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :phone_number, presence: true, length: { is: 11 }, numericality: { only_integer: true }, uniqueness: true
  validates :role, presence: true

  enum :role, { staff: 0, site_owner: 1 }, default: :staff, prefix: true

  has_many :parking_lots, foreign_key: :parking_manager_id
  has_many :parking_areas, through: :parking_lots

  # 有効なアカウントのみログイン許可
  def active_for_authentication?
    super && active?
  end

  # ログイン拒否時のメッセージ
  def inactive_message
    active? ? super : :account_inactive
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
