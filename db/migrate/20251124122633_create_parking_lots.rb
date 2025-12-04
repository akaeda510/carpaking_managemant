class CreateParkingLots < ActiveRecord::Migration[8.1]
  def change
    create_table :parking_lots do |t|
      t.string :name,                null: false
      t.string :prefecture,          null: false
      t.string :city,                null: false
      t.string :street_address,      null: false
      t.string :description
      t.string :total_spaces,        null: false

      t.references :parking_manager, null: false, foreign_key: true
      t.timestamps
    end
  end
end
