class ParkingManagers::EmailConfirmationsController < ApplicationController
  def new
    @email_confirmation = EmailConfirmation.new
  end

  def create
    email = email_confirmation_params[:email]

    if ParkingManager.exists?(email_confirmation_params)
      Rails.logger.info "⚠️ [SKIP] Email already exists: #{email}はすでに登録済みです"
      redirect_to new_parking_manager_session_path, success: "登録用メールが送信されました。"
    else
      Rails.logger.info "📧 [SEND] Preparing to send email to: #{email}の確認レコードを作成します"

      confirmation = EmailConfirmation.create!(email_confirmation_params)
      ParkingManagers::RegistrationMailer.confirmation_link(confirmation).deliver_later

      redirect_to new_parking_manager_session_path, success: "登録用メールが送信されました。"
    end
  end

  private

  def email_confirmation_params
    params.require(:email_confirmation).permit(:email)
  end
end
