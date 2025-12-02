# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#
ParkingManager.find_or_create_by!(email: 'test@example.com') do |manager|
  manager.password = 'password'
  manager.password_confirmation = 'password'

  manager.first_name = '田中',
  manager.last_name = '太郎',
  manager.prefecture = '東京都',
  manager.city = '品川区',
  manager.street_address = '西品川',
  manager.phone_number = '09012345678'
end
puts "ParkingManager: created or found."
