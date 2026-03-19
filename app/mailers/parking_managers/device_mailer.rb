class ParkingManagers::DeviceMailer < BlastengineBaseMailer
  include Rails.application.routes.url_helpers

  def warning_new_device_login(parking_manager, device)
    @parking_manager = parking_manager.decorate
    @device = device.decorate
    @verify_url = verify_devices_url(device_token: @device.device_token)

    login_time = @device.login_timestamp

    html_content = render_to_string(
      template: "parking_managers/mailer/warning_new_device_login",
      formats: [ :html ]
    )

      text_content = <<~TEXT
      #{@parking_manager.full_name} 様

      駐車場管理システムに未登録の端末からログインがありました。
      時刻: #{login_time}
      端末: #{@device.name}

      心当たりがある場合は、以下のURLから端末を登録してください。
      #{@verify_url}
      TEXT


    deliver_via_api(
      from_type: :system,
      to: @parking_manager.email,
      subject: "【重要】新しい端末からのログインを検知しました",
      html_part: html_content,
      text_part: text_content
    )
  end
end
