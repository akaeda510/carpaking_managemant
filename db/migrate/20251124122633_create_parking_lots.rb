class CreateParkingLots < ActiveRecord::Migration[8.1]
  def change
    create_table :parking_lots do |t|
      t.string :name,               null: false, default: ""
      t.string :prefecture,         null: false, default: ""
      t.string :city,               null: false, default: ""
      t.string :street_address,     null: false, default: ""
      t.string :description,                     default: ""
      t.string :total_spaces,       null: false, default: ""

      t.references :parking_manager, foreign_key: true
      t.timestamps
    end
  end
end
