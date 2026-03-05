class ReconstructParkingSpaces < ActiveRecord::Migration[8.1]
  def change
    add_column :parking_areas, :price, :integer, default: 0, null: false

    remove_reference :parking_spaces, :parking_lot, foreign_key: true, index: true

    remove_column :parking_spaces, :parking_type, :integer

    add_reference :parking_spaces, :parking_area, null: false, foreign_key: true
  end
end
