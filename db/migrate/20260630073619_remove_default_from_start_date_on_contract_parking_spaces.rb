class RemoveDefaultFromStartDateOnContractParkingSpaces < ActiveRecord::Migration[8.1]
  def change
    change_column_default :contract_parking_spaces, :start_date, from: "1999-12/31", to: nil
  end
end
