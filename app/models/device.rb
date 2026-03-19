class Device < ApplicationRecord
  validates :device_token, presence: true, uniqueness: true
  validates :user_agent, presence: true
  validates :expires_at, presence: true

  belongs_to :parking_manager

  # 期間内かつ承認済みかどうかを確認
  def active_and_verified?
    expires_at > Time.current && is_verified?
  end

  # 期限を1ヶ月延長
  def extend_expiration!
    update!(expires_at: 1.month.from_now, last_login_at: Time.current)
  end

  # 新しいトークンを生成
  def selt.generate_token
    SecureRandom.uuid
  end
end
