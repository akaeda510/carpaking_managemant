require "pundit"

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout :layout_by_resource

  include Pundit::Authorization

  add_flash_types :success, :danger, :alert

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
      root_path
    end
  end

  def layout_by_resource
    if devise_controller? && resource_name == :admin
      "admin"
    else
      "application"
    end
  end
end
