FactoryBot.define do
  factory :parking_space do
    name { Faker::Number.number(digits: 2) }
    width { Faker::Number.number(digits: 1) }
    length { Faker::Number.number(digits: 1) }
    price = 5000
    status = 0
    association :parking_area
  end
end
