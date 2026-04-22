module TokenConfirmable
  extend ActiveSupport::Concern

  included do
    validates :token, presence: true, uniqueness: true

    before_validation :generate_token, on: :create
  end

  def valid_token?(expires_in: 30.minutes)
    confirmed_at.nil? && confirmation_sent_at > expires_in.ago
  end

  def confirm!
    update!(confirmed_at: Time.current)
  end

  private

  def generate_token
    self.token =SecureRandom.urlsafe_base64(32)
    self.confirmation_sent_at = Time.current
  end
end
