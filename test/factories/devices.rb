FactoryBot.define do
  factory :device do
    device_token { Device.generate_token }
    name { "iPhone(スマホ)" }
    user_agent { "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X" }
    last_login_at { Date.today }
    expires_at { 1.month.from_now}
    is_verified { false }
    association :parking_manager
  end
end
