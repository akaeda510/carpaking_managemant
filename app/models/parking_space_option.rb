class ParkingSpaceOption < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :parking_space_option_assignments, dependent: :destroy
  has_many :parking_space, through: :parking_space_option_assignments
end
