# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
target_email = ENV["TEST_EMAIL"]
manager = ParkingManager.find_by(email: target_email)

if manager
  puts "🗑️  Deleting ParkingManager: #{target_email} and its associated devices..."
  manager.destroy
  puts "✅  Successfully deleted."
else
  puts "ℹ️  ParkingManager with email #{target_email} not found. Skipping."
end

admin_password = ENV.fetch("ADMIN_PASSWORD")

site_owner = Admin.find_or_initialize_by(email: 'admin@example.com')
site_owner.assign_attributes(
  password: admin_password,
  password_confirmation: admin_password,
  first_name: 'テスト',
  last_name: 'アプリ管理者',
  phone_number: '09066666666',
  role: :site_owner,
  active: true
)

if site_owner.save
  puts "Admin '#{site_owner.last_name}': saved successfully."
else
  puts "Admin save failed: #{site_owner.errors.full_messages.join(', ')}"
end

owner_one = ParkingManager.find_or_create_by!(email: 'akaeda510@gmail.com') do |manager|
  manager.password = ENV["password"]
  manager.password_confirmation = ENV["password"]

  manager.first_name = 'テスト'
  manager.last_name = '確認'
  manager.prefecture = '東京都'
  manager.city = '品川区'
  manager.street_address = '西品川'
  manager.phone_number = '09012345678'
end
puts "ParkingManager: created or found."

Contractor.find_or_create_by!(first_name: '坂本') do |user|
  user.parking_manager = owner_one

  user.last_name = '龍馬'
  user.prefecture = '東京都'
  user.city = '渋谷区'
  user.street_address = '代々木'
  user.phone_number = '08011111111'
end
puts "テスト管理者: created or found."

lot = ParkingLot.find_or_create_by!(name: 'テスト用駐車場') do |lot|
  lot.parking_manager = owner_one

  lot.prefecture = '東京都'
  lot.city = '品川区'
  lot.street_address = '西品川'
  lot.total_spaces = 10
end
puts "テスト駐車場: created or found."

area = ParkingArea.find_or_create_by!(name: 'アスファルト', parking_lot: lot) do |area|
  area.default_price = 5000
  area.category = :asphalt
end
puts "テスト駐車エリア: created or found."

options = [ "軽自動車専用", "屋根あり", "駐車時、難あり", "置物として使用禁止", "契約対象車以外駐車禁止", "防犯カメラあり" ]

options.each do |name|
  ParkingSpaceOption.find_or_create_by!(name: name)
end
