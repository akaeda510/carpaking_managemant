class AddMetadataToDevices < ActiveRecord::Migration[8.1]
  def change
    change_column_null :devices, :is_verified, false
  end
end
