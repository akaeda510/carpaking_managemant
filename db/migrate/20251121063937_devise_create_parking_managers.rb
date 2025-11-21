# frozen_string_literal: true

class DeviseCreateParkingManagers < ActiveRecord::Migration[8.1]
  def change
    create_table :parking_managers do |t|
      ## Database authenticatable
         t.string :first_name,         null: false, default: ""
         t.string :last_name,          null: false, default: ""
         t.string :email,              null: false, default: ""
         t.string :password_digest
         t.string :prefecture,         null: false, default: ""
         t.string :city,               null: false, default: ""
         t.string :street_address,     null: false, default: ""
         t.string :building,                        default: ""
         t.string :phone_number,       null: false, default: ""
         t.string :contact_number,                  default: ""
     ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :parking_managers, :email,                unique: true
    add_index :parking_managers, :reset_password_token, unique: true
    # add_index :parking_managers, :confirmation_token,   unique: true
    # add_index :parking_managers, :unlock_token,         unique: true
  end
end
