class ParkingManagerMailer < ApplicationMailer
  def login_notification(parking_manager, remote_ip)
    @parking_manager = parking_manager.decorate
    @remote_ip = remote_ip
    @login_time = Time.current

    mail(
      to: @parking_manager.email,
      subject: "【重要】ログイン通知"
    )
  end
end
