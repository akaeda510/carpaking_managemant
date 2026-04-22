class RenameExpiresAtInEmailConfirmations < ActiveRecord::Migration[8.1]
  def change
    rename_column :email_confirmations, :expires_at, :confirmation_sent_at
    add_column :email_confirmations, :confirmed_at, :datetime
  end
end
