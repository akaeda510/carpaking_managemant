class EmailConfirmation < ApplicationRecord
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true

  def active?
    expires_at > Time.current
  end
end
