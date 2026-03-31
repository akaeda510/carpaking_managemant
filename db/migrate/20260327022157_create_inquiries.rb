class CreateInquiries < ActiveRecord::Migration[8.1]
  def change
    create_table :inquiries do |t|
      t.string :name,    null: false
      t.string :email,   null: false
      t.string :subject
      t.text :message
      t.integer :status, default: 0
      t.references :parking_manager, foreign_key: true, index: true

      t.timestamps
    end
  end
end
