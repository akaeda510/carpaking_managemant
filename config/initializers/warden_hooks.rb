Warden::Manager.after_set_user do |user, auth, opts, scope|
  if opts[:event] == :authentication && user.is_a?(ParkingManager)
    
    token = auth.cookies.permanent[:device_token]
    device = user.devices.find_by(device_token: token)

    if device&.active_and_verified?
      # 既知のデバイスなら通知を送って期間延長
      ParkingManagers::LoginMailer.login_notification(user, device).deliver_later
      device.extend_expiration!
    else

      new_token = Device.generate_token
      new_device = user.devices.create!(
        device_token: new_token,
        name: "新しい端末", 
        user_agent: auth.env['HTTP_USER_AGENT'],
        last_login_at: Time.current,
        expires_at: 1.month.from_now,
        is_verified: false
      )

      # クッキーに新しいトークンを保存
      auth.cookies.permanent[:device_token] = new_device.device_token

      # セッションに保留中のデバイスIDを保存（SessionsControllerで使用）
      auth.request.session[:pending_device_id] = new_device.id
      auth.request.session[:needs_verification] = true

      # メールの送信（API経由）
      ParkingManagers::DeviceMailer.warning_new_device_login(user, new_device).deliver_later
    end
  end
end
