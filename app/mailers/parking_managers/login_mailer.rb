class ParkingManagers::LoginMailer < BlastengineBaseMailer
  def login_notification(parking_manager, device)
    @parking_manager = parking_manager.decorate
    @login_time = Time.current
    @device = device.decorate

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
      text_part: text_content
    )

  end
end
