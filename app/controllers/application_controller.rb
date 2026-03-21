require "pundit"

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
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
        redirect_to root_path, alert: "この端末にはまだ承認されていません。メールを確認して承認を完了してください。"
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
      render file: Rails.public_path.join("403.html"), status: :forbidden, layout: false
    end
  end
end
