class BlastengineBaseMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  abstract_class = true

  protected

  def deliver_via_api(to:, subject:, text_part:, html_part: nil, from_type: :system)

    # 開発環境
    if Rails.env.development?
      from_email = (from_type == :info) ? "info@tukigime-parking.com" : "system@tukigime-parking.com"
      from_name = (from_type == :info) ? "駐車場管理事務所" : "駐車場管理システム"

      return mail(
        to: to,
        subject: subject,
        from: "#{from_name} <#{from_email}"
      ) do |format|
        format.text { render plain: text_part }
        format.html { render html: html_part.html_safe } if html_part.present?
      end
    end

    transaction = Blastengine::Transaction.new

    if from_type == :info
      transaction.from email: "info@tukigime-parking.com", name: "駐車場管理事務所"
    else
      transaction.from email: "system@tukigime-parking.com", name: "駐車場管理システム"
    end

    transaction.to = to
    transaction.subject = subject
    transaction.text_part = text_part
    transaction.html_part = html_part if html_part.present?

    begin
      response = transaction.__send__(:send)
      Rails.logger.info "--- [Blastengine] Sent successfully. ID: #{response} ---"
      response
    rescue => e
      Rails.logger.error "--- [Blastengine] Delivery Error: #{e.message} ---"
      raise e
    end
  end
end
