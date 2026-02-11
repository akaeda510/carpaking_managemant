class CreateParkingSpaceOptions < ActiveRecord::Migration[8.1]
  def change
    create_table :parking_space_options do |t|
      t.string :name,               null: false

      t.timestamps
      t.index :name
    end
  end
end
