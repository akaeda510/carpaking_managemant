class Device < ApplicationRecord
  validates :device_token, presence: true, uniqueness: true
  validates :user_agent, presence: true
  validates :expires_at, presence: true

  belongs_to :parking_manager

  before_validation :set_device_name, if: :will_save_change_to_user_agent?

  DEVICE_TYPES = {
    /iPhone/i    => "お使いのiPhone(アイフォン)",
    /iPad/i      => "お使いのiPad(タブレット)",
    /Android/i   => "お使いのAndroid端末(スマートフォン)",
    /Windows/i   => "お使いのWindows(パソコン)",
    /Macintosh/i => "お使いのMac(パソコン)"
  }.freeze

  def self.set_name_by_user_agent(user_agent)
    user_agent_string = user_agent.to_s
    DEVICE_TYPES.find { |pattern, _name| user_agent_string.match?(pattern) }&.last || "不明な端末"
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
  def self.generate_token
    SecureRandom.uuid
  end

  def verify!
    update(is_verified: true)
  end

  private

  def set_device_name
    self.name = self.class.set_name_by_user_agent(user_agent)
  end
end
