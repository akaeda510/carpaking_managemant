# frozen_string_literal: true

class ParkingManagers::SessionsController < Devise::SessionsController
  skip_before_action :require_no_authentication, only: [:wait_verification]
  skip_before_action :authenticate_parking_manager!, only: [:wait_verification], raise: false
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:success, :signed_in)
    sign_in(resource_name, resource)

    if session[:needs_verification]
      flash[:alert] = "新しい端末を感知しました。メールを確認してください。"
      respond_with resource, location: wait_verification_path
    else
      set_flash_messge!(:seccess, :signed_in)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def wait_verification
    Rails.logger.info "PENDING_ID in session: #{session[:pending_device_id]}"
    pending_id = session[:pending_device_id]

    if pending_id.present?
      @device = Device.find(pending_id)
      render :wait_verification
    else
      redirect_to new_parking_manager_session_path, alert: "認証の有効期限が切れました。もう一度ログインからやり直してください"
    end

  rescue ActiveRecord::RecordNotFound
    redirect_to new_parking_manager_session_path, alert: "端末情報が見つかりませんでした。再度ログインをお願いします。"
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
