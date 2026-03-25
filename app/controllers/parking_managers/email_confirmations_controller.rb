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

    redirect_to new_parking_manager_session_path, success: "ご入力いただいたメールアドレス宛に、登録URLを送信しました（有効期間： 30分）。"
  end
end
