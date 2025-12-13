class AddManagerToContractParkingSpace < ActiveRecord::Migration[8.1]
  def change
    add_reference :contract_parking_spaces, :parking_manager, null: false, foreign_key: true
  end
end
