class ParkingManagers::LoginMailer < ApplicationMailer
  def login_notification(parking_manager, ip_address)
    @parking_manager = parking_manager.decorate

    transaction = Blastengine::Transaction.new
    transaction.from(email: "info@tukigime-parking.com")
    transaction.to(address: @parking_manager.email)
    transaction.subject("【重要】ログイン通知")

    transaction.text_part(render_to_string(template: "notification_mailer/login_notification"))

    transaction.deliver
  end
end
