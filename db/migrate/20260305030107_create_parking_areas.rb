class CreateParkingAreas < ActiveRecord::Migration[8.1]
  def change
    create_table :parking_areas do |t|
      t.references :parking_lot, null: false, foreign_key: true
      t.string :name
      t.integer :category

      t.timestamps
    end
  end
end
