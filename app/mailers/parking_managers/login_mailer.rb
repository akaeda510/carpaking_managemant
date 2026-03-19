class ParkingManagers::LoginMailer < ApplicationMailer
  def login_notification(parking_manager)
    @parking_manager = parking_manager.decorate
    @login_time = Time.current

    deliver_via_api(
      to = @parking_manager.email,
      subject = "【重要】ログイン通知"
    )

    html_part = render_to_string(
      template: "parking_managers/mailer/login_notification",
      formats: [ :html ]
    )

    text_part = "駐車場管理システムにログインがありました。日時: #{@login_time}"

  end
end
