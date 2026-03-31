class Inquiry < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :subject, presence: true
  validates :message, presence: true, length: { maximum: 350 }
  enum :status, { unread: 0, processing: 1, completed: 2 }, prefix: true, default: :unread

  belongs_to :parking_manager, optional: true
end
