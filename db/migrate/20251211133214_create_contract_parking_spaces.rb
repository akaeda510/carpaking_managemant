class CreateContractParkingSpaces < ActiveRecord::Migration[8.1]
  def change
    create_table :contract_parking_spaces do |t|
      t.date :start_date,    null: false, default: "1999-12-31"
      t.date :end_date,      null: false, default: "2999-12-31"

      t.references :contractor, null: false, foreign_key: true
      t.references :parking_space, null: false, foreign_key: true

      t.timestamps
    end
  end
end
