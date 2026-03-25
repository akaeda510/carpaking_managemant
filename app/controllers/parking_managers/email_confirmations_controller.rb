class ParkingManagers::EmailConfirmationsController < ApplicationController
  def new
    @email_confirmation = EmailConfirmation.new
  end

  def create
    email = params[:email_confirmation][:email]

    unless ParkingManager.exists?(email: email)
      confirmation = EmailConfirmation.create!(
        email: email,
        token: SecureRandom.urlsafe_base64(32),
        expires_at: 30.minutes.from_now
      )

      ParkingManagers::RegistrationMailer.confirmation_link(confirmation).deliver_later
    end

    redirect_to new_parking_manager_session_path, success: "登録用メールが送信されました。"
  end
end
