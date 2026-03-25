Warden::Manager.after_set_user do |user, auth, opts, scope|
  if opts[:event] == :authentication && user.is_a?(ParkingManager)

    user_agent = auth.request.user_agent
    token = auth.cookies[:device_token]
    device = user.devices.find_by(device_token: token)

    if device&.active_and_verified?
      device.update!(user_agent: user_agent)
      # 既知のデバイスなら通知を送って期間延長
      ParkingManagers::LoginMailer.login_notification(user, device, auth.request.remote_ip).deliver_later
      device.extend_expiration!
    else

      new_token = Device.generate_token
      new_device = user.devices.create!(
        device_token: new_token,
        name: Device.get_type_by_user_agent(user_agent),
        user_agent: auth.request.user_agent,
        last_login_at: Time.current,
        expires_at: 1.month.from_now,
        is_verified: false
      )

      # クッキーに新しいトークンを保存
      auth.cookies[:device_token] = { value: new_token, expires: 1.month.from_now }

      # セッションに保留中のデバイスIDを保存（SessionsControllerで使用）
      auth.request.session[:pending_device_id] = new_device.id
      auth.request.session[:needs_verification] = true

      # メールの送信（API経由）
      ParkingManagers::DeviceMailer.warning_new_device_login(user, new_device, auth.request.remote_ip).deliver_later
    end

  elsif auth.request.session[:needs_verification]
    token = auth.cookies[:device_token]
    device = user.devices.find_by(device_token: token)

    if device&.active_and_verified?
      auth.request.session.delete(:needs_verification)
      auth.request.session.delete(:pending_device__id)
      device.extend_expiration!
    else
    end
  end
end
