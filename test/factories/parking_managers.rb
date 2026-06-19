FactoryBot.define do
  factory :parking_manager do
    
    first_name { Faker::JapaneseName.first_name }
    last_name { Faker::JapaneseName.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    prefecture { Faker::Address.prefecture }
    city { Faker::Address.city }
    street_address { Faker::Address.street_address }
    phone_number { Faker::Number.number(digits: 11).to_s }
    contact_number { Faker::Number.number(digits: 10).to_s }
    terms_of_service { true }
  end
end
