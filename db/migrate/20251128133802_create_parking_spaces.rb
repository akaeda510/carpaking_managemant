class CreateParkingSpaces < ActiveRecord::Migration[8.1]
  def change
    create_table :parking_spaces do |t|
      t.string :name,          null: false
      t.string :description
      t.decimal :width,        precision: 3, scale: 2
      t.decimal :length,       precision: 3, scale: 2

      t.references :parking_lot, foreign_key: true
      t.references :parking_manager, foreign_key: true

      t.timestamps

      t.index :name
    end
    add_index :parking_spaces, [:parking_manager_id, :parking_lot_id], unique: true

  end
end
