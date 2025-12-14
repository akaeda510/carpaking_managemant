class CreateContractors < ActiveRecord::Migration[8.1]
  def change
    create_table :contractors do |t|
      t.string :first_name,          null: false
      t.string :last_name,           null: false
      t.string :prefecture,          null: false
      t.string :city,                null: false
      t.string :street_address,      null: false
      t.string :building
      t.string :phone_number,        null: false
      t.string :contact_number
      t.string :notes

      t.references :parking_manager, null: false, foreign_key: true

      t.timestamps
    end
  end
end
