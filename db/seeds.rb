# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
site_owner = Admin.find_or_create_by!(email: 'admin@example.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'

  admin.first_name = '井口'
  admin.last_name = '拓人'
  admin.phone_number = '09066666666'
  admin.role = :site_owner
  admin.active = true
end
puts "Admin_id, '井口拓人': created or found."

owner_one = ParkingManager.find_or_create_by!(email: 'test@example.com') do |manager|
  manager.password = 'password'
  manager.password_confirmation = 'password'

  manager.first_name = '田中'
  manager.last_name = '太郎'
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
puts "Contractor: created or found."

lot = ParkingLot.find_or_create_by!(name: 'テスト用駐車場') do |lot|
  lot.parking_manager = owner_one

  lot.prefecture = '東京都'
  lot.city = '品川区'
  lot.street_address = '西品川'
  lot.total_spaces = 10
end
puts "ParkingLot: created or found."

ParkingSpace.find_or_create_by!(name: 'テスト1') do |space|
  space.parking_manager = owner_one
  space.parking_lot = lot

  space.width = 2.5
  space.length = 5
  space.description = 'テストとして作成'
end
puts "ParkingSpace: created or found."

options = [ "軽自動車専用", "屋根あり", "駐車時、難あり", "置物として使用禁止", "契約対象車以外駐車禁止" ]

options.each do |name|
  ParkingSpaceOption.find_or_create_by!(name: name)
end
