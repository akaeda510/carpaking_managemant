FactoryBot.define do
  factory :contract_parking_space do
    start_date { Date.today }
    end_date { 1.month.from_now }
    association :parking_manager
    association :parking_space
    association :contractor
  end
end
