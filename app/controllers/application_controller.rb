require "pundit"

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :confirm_device_verified!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  layout :layout_by_resource

  include Pundit::Authorization

  add_flash_types :success, :danger, :alert

  def pundit_user
    current_parking_manager
  end

  def confirm_device_verified!
    return if devise_controller? || !parking_manager_signed_in?

    if session[:needs_verification]
      allowed_paths = [
        wait_verification_path,
        "/parking_managers/devices/verify",
        destroy_parking_manager_session_path
      ]
      unless allowed_paths.any? { |path| request.path.include?(path) }
        redirect_to wait_verification_path, alert: "この端末にはまだ承認されていません。メールを確認して承認を完了してください。"
      end
    end
  end

  protected

  def current_user
    current_parking_manager
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :first_name,
      :last_name,
      :prefecture,
      :city,
      :street_address,
      :building,
      :phone_number,
      :contact_number
    ])

    devise_parameter_sanitizer.permit(:account_update, keys: [
      :first_name,
      :last_name,
      :prefecture,
      :city,
      :street_address,
      :building,
      :phone_number,
      :contact_number
    ])
  end

  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :admin
      new_admin_session_path
    else
      new_parking_manager_session_path
    end
  end

  def layout_by_resource
    if devise_controller? && resource_name == :admin
      "admin"
    else
      "application"
    end
  end

  def user_not_authorized
    render file: Rails.public_path.join("403.html").to_s, status: :forbidden, layout: false
  end

  def clear_auth_session_data(confirmation_token: nil)
    session.delete(:need_varification)
    session.delete(:pending_device_id)
    session.delete(:user_remember_me)
    if confirmation_token.present?
      EmailConfirmation.find_by(token: confirmation_token)&.destroy
    end
    Rails.logger.info "--- Auth session and token cleared ---"
  end

  def auth_dependent_redirect_path(resource)
    if parking_manager_signed_in?
      after_sign_in_path_for(resource)
    else
      new_parking_manager_session_path
    end
  end

  def persist_session_on_failure(resource)
    bypass_sign_in(resource, scope: :parking_manager)
  end

  private

  def set_device_cookie(device)
    return unless device
    device.update(last_login_at: Time.current)

    cookies[:device_token] = {
      value: device.device_token,
      expires: 1.month.from_now,
      httponly: true,
      path: "/",
      secure: Rails.env.production?
    }
  end
end
