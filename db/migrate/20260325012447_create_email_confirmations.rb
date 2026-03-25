class CreateEmailConfirmations < ActiveRecord::Migration[8.1]
  def change
    create_table :email_confirmations do |t|
      t.string :email,        null: false
      t.string :token,        null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end
    add_index :email_confirmations, :token, unique: true
  end
end
