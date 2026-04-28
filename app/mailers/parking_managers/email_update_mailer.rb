class ParkingManagers::EmailUpdateMailer < BaseMailer
  def email_update(email_change)
    @email_change = email_change
    @parking_manager = @email_change.parking_manager.decorate

    html_content = render_to_string(
      template: "parking_managers/mailer/email_update",
      formats: [ :html ]
    )

    text_content = "メールアドレスが更新されました。"

    deliver_via_api(
      from_type: :info,
      to:  @email_change.new_email,
      subject: "【重要】メールアドレス更新完了のお知らせ",
      html_part: html_content,
      text_part: text_content
    )
  end
end
