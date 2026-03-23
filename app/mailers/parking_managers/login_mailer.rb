class ParkingManagers::LoginMailer < BlastengineBaseMailer
  def login_notification(parking_manager, device, remote_ip)
    @parking_manager = parking_manager.decorate
    @login_time = Time.current

    location = Geocoder.search(remote_ip).first
    city_info = location&.city.present? ? "#{location.city}付近の" : "不明な場所の"

    device_label = Device.set_name_by_user_agent(device.user_agent, nil)

    @friendly_device_name = "#{city_info}#{device_label}"

    html_content = render_to_string(
      template: "parking_managers/mailer/login_notification",
      formats: [ :html ]
    )

    text_content = "駐車場管理システムにログインがありました。日時: #{@login_time}"

    deliver_via_api(
      from_type: :system,
      to:  @parking_manager.email,
      subject: "【重要】ログイン通知",
      html_part: html_content,
      text_part: "ログインがありました。端末: #{@friendly_device_name}"
    )
  end
end
