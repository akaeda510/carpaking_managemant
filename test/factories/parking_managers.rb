FactoryBot.define do
  factory :parking_manager do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    prefecture { I18n.t("prefectures").values.sample }
    city { Faker::Address.city }
    street_address { Faker::Address.street_address }
    phone_number { Faker::Number.number(digits: 11).to_s }
    contact_number { Faker::Number.number(digits: 10).to_s }
    terms_of_service { true }
  end
end
