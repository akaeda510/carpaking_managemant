class AddParkingTypeToParkingSpace < ActiveRecord::Migration[8.1]
  def change
    add_column :parking_spaces, :parking_type, :integer, default: 0
  end
end
