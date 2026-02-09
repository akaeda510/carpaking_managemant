class CreateGarageDetails < ActiveRecord::Migration[8.1]
  def change
    create_table :garage_details do |t|
      t.decimal :height,             precision: 3, scale: 1,                                          default: 0

      t.references :parking_space,   null: false, foreign_key: true
      t.timestamps
    end
  end
end
