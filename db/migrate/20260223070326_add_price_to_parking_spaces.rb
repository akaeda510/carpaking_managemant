class AddPriceToParkingSpaces < ActiveRecord::Migration[8.1]
  def change
    add_column :parking_spaces, :price, :integer, default: 0, null: false
  end
end
