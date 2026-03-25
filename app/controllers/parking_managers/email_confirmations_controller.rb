class ParkingManagers::EmailConfirmationsController < ApplicationController
  def new
    @email_confirmation = EmailConfirmation.new
  end

  def create
    email = params[:email_confirmation][:email]

    if ParkingManager.exists?(email: email)
      Rails.logger.info "⚠️ [SKIP] Email already exists: #{email}はすでに登録済みです"
    else
      Rails.logger.info "📧 [SEND] Preparing to send email to: #{email}の確認レコードを作成します"

      confirmation = EmailConfirmation.create!(
        email: email,
        token: SecureRandom.urlsafe_base64(32),
        expires_at: 30.minutes.from_now
      )

      ParkingManagers::RegistrationMailer.confirmation_link(confirmation).deliver_later

      redirect_to new_parking_manager_session_path, success: "登録用メールが送信されました。"
    end
  end
end
