class RemovePasswordDigestFromParkingManagers < ActiveRecord::Migration[8.1]
  def change
    remove_column :parking_managers, :password_digest, :string
  end
end
