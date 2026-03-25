class ParkingManagers::RegistrationMailer < BaseMailer
  def confirmation_link(email_confirmation)
    @email = email_confirmation.email
    @token = email_confirmation.token
    @confirmation = email_confirmation
    @registration_url = new_parking_manager_registration_with_token_url(token: @token)

    subject = "【駐車場管理システム】アカウント登録を完了してください"

    html_content = render_to_string(template: "parking_managers/mailer/registration")
    text_content = "以下のURLから本登録を完了してください。\n#{@registration_url}"

    deliver_via_api(
      to: @email,
      subject: subject,
      text_part: text_content,
      html_part: html_content
    )
  end
end
