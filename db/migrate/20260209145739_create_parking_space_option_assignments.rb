class CreateParkingSpaceOptionAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :parking_space_option_assignments do |t|
      t.references :parking_space,        null: false, foreign_key: true
      t.references :parking_space_option, null: false, foreign_key: true

      t.timestamps
    end
  end
end
