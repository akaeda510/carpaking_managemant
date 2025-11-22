class AddDeviseColumnsToParkingManagers < ActiveRecord::Migration[8.1]
  def change
    add_column :parking_managers, :encrypted_password, :string, null: false, default: ""
  end
end
