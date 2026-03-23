require "resend"

class BaseMailer < ApplicationMailer
  include Rails.application.routes.url_helpers
  RESEND_CLIENT = Resend::Client.new(ENV["RESEND_API_KEY"])

  abstract_class = true

  protected

  def deliver_via_api(to:, subject:, text_part:, html_part: nil, from_type: :system)
    from_email = (from_type == :info) ? "info@tukigime-parking.com" : "system@tukigime-parking.com"
    from_name = (from_type == :info) ? "駐車場管理事務所" : "駐車場管理システム"
    from_full = "#{from_name}<#{from_email}>"

    # 開発環境
    if Rails.env.development?
      return mail(
        to: to,
        subject: subject,
        from: from_full,
      ) do |format|
        format.text { render plain: text_part }
        format.html { render html: html_part.html_safe } if html_part.present?
      end
    end

    params = {
      from: from_full,
      to: [ to ],
      subject: subject,
      text: text_part,
      html: html_part
    }

    begin
      response = RESEND_CLIENT.emails.send(params)
      Rails.logger.info "--- [Resend] Sent successfully. ID: #{response} ---"
      response
    rescue => e
      Rails.logger.error "--- [Resend] Delivery Error: #{e.message} ---"
      raise e
    end
  end
end
