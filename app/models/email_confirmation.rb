class EmailConfirmation < ApplicationRecord
  include TokenConfirmable

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true
end
