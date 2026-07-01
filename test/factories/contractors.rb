FactoryBot.define do
  factory :contractor do
    first_name { Faker::Name.last_name }
    last_name { Faker::Name.first_name }
    prefecture { I18n.t("prefectures").values.sample }
    city { Faker::Address.city }
    street_address { Faker::Address.street_address }
    phone_number { Faker::Number.number(digits: 11).to_s }
    contact_number { Faker::Number.number(digits: 10).to_s }
    association :parking_manager
  end
end
