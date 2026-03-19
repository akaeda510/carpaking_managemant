Warden::Manager.after_set_user do |user, auth, opts|
  if opts[:event] == :authentication && user.is_a?(ParkingManager)

    token = auth.cookies.permanent[:device_token]
    device = user.devices.find_by(device_token: token)

    if device&.active_and_verified?
      ParkingManagers.login_notification(user, device).deliver_later
      # スライディング方式でトークンの期間を延長
      device.extend_expiration!

    else # 新規トークン発行と警告メール
      new_token = Device.generate_token
      new_device = user.devices.create!(
        device_token: new_token,
        user_agent: auth.request.user_agent,
        expires_at: 1.month.from_now,
        name: "自動登録端末",
        last_login_at: Time.current, 
        is_verified: false
      )

      auth.cookies.permanent[:device_token] = new_token

      ParkingManagers::DeviceMailer.warning_new_device_login(user, new_device).deliver_later
    end
  end
end
