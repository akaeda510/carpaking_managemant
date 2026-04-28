class ParkingManagers::EmailChange < ApplicationRecord
  include TokenConfirmable
  self.table_name = "email_changes"

  belongs_to :parking_manager

  validates :new_email, presence: true, format: { with: Devise.email_regexp }, uniqueness: { scope: parking_manager_id}
  validate :email_must_be_different
  private

  def email_must_be_different
    if new_email == parking_manager.email
      errors.add(:new_email, "現在のメールアドレスと同じものは登録できません")
    end
  end
end
