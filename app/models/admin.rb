class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :phone_number, presence: true, length: { is: 11 }, numericality: { only_integer: true }, uniqueness: true
  validates :role, presentce: true

  enum :role, { staff: 0, site_owner: 1 }, default: :staff

  # 有効なアカウントのみログイン許可
  def active_for_authentication?
    super && active?
  end

  # ログイン拒否時のメッセージ
  def inactive_message
    active? ? super : :account_inactive
  end
end
