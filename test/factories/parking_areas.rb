FactoryBot.define do
  factory :parking_area do
    name { Faker::Name.name }
    default_price = 5000
    association :parking_lot
    category = asphalt
  end
end
