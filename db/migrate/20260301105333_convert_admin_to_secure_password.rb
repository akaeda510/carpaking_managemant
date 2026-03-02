class ConvertAdminToSecurePassword < ActiveRecord::Migration[8.1]
  def change
    rename_column :admins, :encrypted_password, :password_digest

    remove_index :admins, :reset_password_token if index_exists?(:admins, :reset_password_token)

    remove_column :admins, :reset_password_token, :string
    remove_column :admins, :reset_password_sent_at, :datetime
    remove_column :admins, :remember_created_at, :datetime
  end
end
