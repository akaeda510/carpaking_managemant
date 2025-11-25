# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_24_122633) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "parking_lots", force: :cascade do |t|
    t.string "city", default: "", null: false
    t.datetime "created_at", null: false
    t.text "description", default: ""
    t.string "name", default: "", null: false
    t.bigint "parking_manager_id"
    t.string "prefecture", default: "", null: false
    t.string "street_address", default: "", null: false
    t.string "total_spaces", default: "", null: false
    t.datetime "updated_at", null: false
    t.index ["parking_manager_id"], name: "index_parking_lots_on_parking_manager_id"
  end

  create_table "parking_managers", force: :cascade do |t|
    t.string "building", default: ""
    t.string "city", default: "", null: false
    t.string "contact_number", default: ""
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "phone_number", default: "", null: false
    t.string "prefecture", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "street_address", default: "", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_parking_managers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_parking_managers_on_reset_password_token", unique: true
  end

  add_foreign_key "parking_lots", "parking_managers"
end
