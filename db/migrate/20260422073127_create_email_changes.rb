class CreateEmailChanges < ActiveRecord::Migration[8.1]
  def change
    create_table :email_changes do |t|
      t.references :parking_manager,    null: false, foreign_key: true
      t.string :new_email,              null: false
      t.string :token,                  null: false
      t.datetime :confirmation_sent_at
      t.datetime :confirmed_at

      t.timestamps
    end

    add_index :email_changes, :token, unique: true
  end
end
