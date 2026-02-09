class CreateParkingSpaceOptions < ActiveRecord::Migration[8.1]
  def change
    create_table :parking_space_options do |t|
      t.string :name,               null: false

      t.references :parking_space,     null: false, foreign_key: true

      t.timestamps

      t.index :name
    end
  end
end
