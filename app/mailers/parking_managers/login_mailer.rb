class ParkingManagers::LoginMailer < ApplicationMailer
  def login_notification(parking_manager, ip_address)
    @parking_manager = parking_manager.decorate

    transaction = Blastengine::Transaction.new
    transaction.from email: "info@tukigime-parking.com", name: "管理者"
    transaction.to = @parking_manager.email
    transaction.subject = "【重要】ログイン通知"

    transaction.text_part = render_to_string(template: "parking_managers/login_mailer/login_notification")

    delivery_id = transaction.send

    Rails.logger.info "--- Blastengine Email Sent! ID: #{delivery_id} ---"
  end
end
