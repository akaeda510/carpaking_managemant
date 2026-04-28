class ParkingManagers::EmailChange < ApplicationRecord
  include TokenConfirmable
  self.table_name = "email_changes"

  belongs_to :parking_manager

  validates :new_email, presence: true, format: { with: Devise.email_regexp }, uniqueness: { scope: :parking_manager_id, message: "はすでにこの申請で使用されています。" }

  validate :email_must_be_different
  validate :email_must_not_be_taken
  validate :email_must_be_pending_other

  private

  def input_ready?
    new_email.present? && parking_manager.present?
  end

  def email_must_be_different
    return if input_ready?
    if new_email == parking_manager.email
      errors.add(:new_email, "現在のメールアドレスと同じものは登録できません")
    end
  end

  # すでに会員登録されているか
  def email_must_not_be_taken
    return if input_ready?
    if ParkingManagers::ParkingManager.exists?(email: new_email)
      errors.add(:new_email, "はすでに他のアカウントで使用されています")
    end
  end

  # 同時に同じアドレスを変更申請しているか
  def email_must_be_pending_other
    return if input_ready?
    if ParkingManagers::EmailChange.where.not(id: id).exists?(new_email: new_email, confirmed_at: nil)
      errors.add(:new_email, "現在、このメールアドレスは他の申請で使用されています")
    end
  end
end
