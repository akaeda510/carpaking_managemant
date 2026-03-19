class CreateDevices < ActiveRecord::Migration[8.1]
  def change
    create_table :devices do |t|
      t.references :parking_manager, null: false, foreign_key: true
      t.string :device_token,        null: false
      t.string :name
      t.string :user_agent,          null: false
      t.datetime :last_login_at
      t.datetime :expires_at
      t.boolean :is_verified

      t.timestamps
    end
    add_index :devices, :device_token
    add_index :devices, :expires_at
  end
end
