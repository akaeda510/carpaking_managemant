class NotificationMailer < ApplicationMailer
  def login_notification(parking_manager)
    @parking_manager = parking_manager.decorate

    transaction = Blastengine::Transaction.new
    transaction.form = 'info@tukigime-parking.com'
    transaction.to = @parking_manager.email
    transaction.subject = '【重要】ログイン通知'

    transaction.text_part = render_to_string(template: 'notification_mailer/login_notification')

    transaction.deliver
  end
end
