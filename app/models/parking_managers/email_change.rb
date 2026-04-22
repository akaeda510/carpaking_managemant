class ParkingManagers::EmailChange < ApplicationRecord
  include TokenConfirmable
  self.table_name = "email_changes"

  belongs_to :parking_manager

  validates :new_email, presence: true, format: { with: Devise.email_regexp }
end
