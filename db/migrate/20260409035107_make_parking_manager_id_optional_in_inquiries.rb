class MakeParkingManagerIdOptionalInInquiries < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :inquiries, :parking_managers

    change_column_null :inquiries, :parking_manager_id, true
  end
end
