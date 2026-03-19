class Device < ApplicationRecord
  validates :device_token, presence: true, uniqueness: true
  validates :user_agent, presence: true
  validates :expires_at, presence: true

  belongs_to :parking_manager

  DEVICE_TYPES = {
    /iPhone/i    => 'iPhone',
    /iPad/i      => 'iPad',
    /Android/i   => 'Android端末',
    /Windows/i   => 'Windows PC',
    /Macintosh/i => 'Mac'
  }.freeze

  def self.set_name_by_user_agent(user_agent)
    user_agent_string = user_agent.to_s
    DEVICE_TYPES.find { |pattern, name| user_agent_string.match?(pattern) }&.last || '不明な端末'
  end

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

  def 
end
