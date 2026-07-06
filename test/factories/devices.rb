FactoryBot.define do
  factory :device do
    device_token { Device.generate_token }
    name { "iPhone(スマホ)" }
    user_agent { "iphone" }
    last_login_at { Time.current }
    expires_at { 1.month.from_now }
    is_verified { false }
    association :parking_manager
  end
end
