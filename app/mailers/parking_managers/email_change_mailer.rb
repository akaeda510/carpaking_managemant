class ParkingManagers::EmailChangeMailer < BaseMailer
  def email_reset(email_change, remote_ip)
    @email_change = email_change
    @parking_manager = @email_change.parking_manager.decorate
    @friendly_device_name = @parking_manager.devices.last&.decorate&.friendly_name(remote_ip)

    html_content = render_to_string(
      template: "parking_managers/mailer/email_change",
      formats: [ :html ]
    )

    text_content = "メールアドレス再設定の申請がありました。端末: #{@friendly_device_name}"

    deliver_via_api(
      from_type: :info,
      to:  @parking_manager.email,
      subject: "【重要】メールアドレス再設定",
      html_part: html_content,
      text_part: text_content
    )
  end
end
