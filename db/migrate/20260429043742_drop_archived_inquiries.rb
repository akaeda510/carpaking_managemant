class DropArchivedInquiries < ActiveRecord::Migration[8.1]
  def change
    if table_exists?(:archived_inquiries)
      drop_table :archived_inquiries
    else
      puts "⚠️ table 'archived_inquiries' does not exist. Skipping..."
    end
  end
end
