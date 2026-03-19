class ParkingManagers::LoginMailer < ApplicationMailer
  def login_notification(parking_manager, ip_address)
    @parking_manager = parking_manager.decorate
    @login_time = Time.current
    @@remote_ip = ip_address

    transaction = Blastengine::Transaction.new
    transaction.from email: "info@tukigime-parking.com", name: "管理者"
    transaction.to = @parking_manager.email
    transaction.subject = "【重要】ログイン通知"

    transaction.html_part = render_to_string(
      template: "parking_managers/mailer/login_notification",
      formats: [:html]
    )

    transaction.text_part = "駐車場管理システムにログインがありました。日時: #{@login_time}"

    delivery_id = transaction.__send__(:send)

    Rails.logger.info "--- Blastengine Email Sent! ID: #{delivery_id} ---"
  end
end
