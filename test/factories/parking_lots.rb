FactoryBot.define do
  factory :parking_lot do
    name { Faker::Name.name }
    prefecture { I18n.t("prefectures").values.sample }
    city { Faker::Address.city }
    street_address { Faker::Address.street_address }
    total_spaces { Faker::Number.number(digits: 2) }
    association :parking_manager
  end
end
