class CreateParkingSpaces < ActiveRecord::Migration[8.1]
  def change
    create_table :parking_spaces do |t|
      t.string :name,                null: false
      t.string :description
      t.decimal :width,              precision: 2, scale: 1
      t.decimal :length,             precision: 2, scale: 1
      t.decimal :height,             precision: 2, scale: 1
      
      t.integer :parking_type,       null: false, default: 0 

      t.references :parking_lot,     null: false, foreign_key: true
      t.references :parking_manager, null: false, foreign_key: true

      t.timestamps

      t.index :name
      t.index :parking_type
    end
  end
end
