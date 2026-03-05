class AddSnapshotColumnsToContractParkingSpaces < ActiveRecord::Migration[8.1]
  def change
    add_column :contract_parking_spaces, :applied_price, :integer
    add_column :contract_parking_spaces, :space_name_at_contract, :string
    add_column :contract_parking_spaces, :area_category_at_contract, :integer
  end
end
