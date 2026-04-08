class ParkingManagerMailer < BaseMailer
  include Devise::Mailers::Helpers

  def reset_password_instructions(record, token, opts = {})
    @token = token
    @resource = record

    send_resend_mail(record, "パスワード再設定のご案内")
  end

  private

  def send_resend_mail(record, subject_text)
    text_part = render_to_string(
      template: "parking_managers/mailer/#{action_name}",
      formats: [ :text ]
    )
    html_part = render_to_string(
      template: "parking_managers/mailer/#{action_name}",
      formats: [ :html ]
    )

    deliver_via_api(
      to: record.email,
      subject: subject_text,
      text_part: text_part,
      html_part: html_part,
      from_type: :system
    )
  end
end
