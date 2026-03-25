class CreateEmailConfirmations < ActiveRecord::Migration[8.1]
  def change
    create_table :email_confirmations do |t|
      t.string :email
      t.string :token
      t.datetime :expires_at

      t.timestamps
    end
    add_index :email_confirmations, :token
  end
end
