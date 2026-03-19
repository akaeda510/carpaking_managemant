class ParkingManagers::DeviceMailer < ApplicationMailer
  def warning_new_device_login(parkingmanager, device)
    @parking_manager = parking_manager.decorate
    @device = device
    @verify_url = verify_device_url(@device.device_token)

    transaction = Blastengine::Transaction.new
    transaction.from email: "system@tukigime-parking.com", name: "システム"
    transaction.to = @parking_manager.email
    transaction.subject = "【重要】新しい端末からのログインを検知しました"

    transaction.html_part = render_to_string(
      template: "parking_managers/mailer/warning_new_device_login",
      formats: [ :html ]
    )

    login_time = I18n.l(@device.last_login_at, format: :long)
    transaction.text_part = <<~TEXT
    #{@parking_manager.full_name} 様

    駐車場管理システムに未登録の端末からログインがありました。
    時刻: #{login_time}
    端末: #{@device.name}

    心当たりがある場合は、以下のURLから端末を登録してください。
    #{@verify_url}
    TEXT

    delivery_id = transaction.__send__(:send)

    Rails.logger.info "--- Blastengine Email Sent! ID: #{delivery_id} ---"
  end
end
