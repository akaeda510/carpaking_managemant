class AddStatusToParkingSpaces < ActiveRecord::Migration[8.1]
  def change
    add_column :parking_spaces, :status, :integer, default: 0, null: false
  end
end
