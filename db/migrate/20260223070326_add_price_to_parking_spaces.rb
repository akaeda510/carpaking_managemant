class AddPriceToParkingSpaces < ActiveRecord::Migration[8.1]
  def change
    add_column :parking_spaces, :price, :integer
  end
end
