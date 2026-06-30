class AddEndDateUndeterminedToContractParkingSpaces < ActiveRecord::Migration[8.1]
  def change
    add_column :contract_parking_spaces, :end_date_undetermined, :boolean, default: false, null: false
  end
end
