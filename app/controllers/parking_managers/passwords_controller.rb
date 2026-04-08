# frozen_string_literal: true

class ParkingManagers::PasswordsController < Devise::PasswordsController
  prepend_before_action :authenticate_parking_manager!, only: %i[ new create edit update ], if: -> { parking_manager_signed_in? }
  skip_before_action :require_no_authentication, only: %i[ new create edit update ]
  append_before_action :assert_reset_token_passed, only: :edit
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      set_flash_message!(:notice, :send_instructions)
      respond_with resource, location: auth_dependent_redirect_path(resource)
    else
      respond_with(resource)
    end
  end

  def edit
    # パスワードリセット後、トークンを失効し、独自のパスを指定
    resource = resource_class.with_reset_password_token(params[:reset_password_token])

    unless resource&& resource.reset_password_period_valid?
      set_flash_message! :alert, :no_token_found

      if parking_manager_signed_in?
        redirect_to after_sign_in_path_for(current_parking_manager)
      else
        redirect_to new_parking_manager_session_path
      end
      return
    end

    super
  end

  # PUT /resource/password
  def update
    # 処理初めのログイン状態を記録
    signed_in_before_update = parking_manager_signed_in?

    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      register_and_verify_current_device(resource)
      complete_auth_flow(resource, confirmation_token: params[:reset_password_token])

      # 未ログイン状態の場合、ログインを解除
      if !signed_in_before_update && parking_manager_signed_in?
        sign_out(resource_name)
      end

      set_flash_message!(:notice, :updated)
      # パスワードへんこうで切れたセッションを上書きして保持
      respond_with resource, location: auth_dependent_redirect_path(resource)
    else
      persist_session_on_failure(resource)
      # 最低文字数を表示
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def register_and_verify_current_device(resource)
    device = Device.find_or_initialize_by(parking_manager: resource, device_token: cookies[:device_token])
    # デバイスの検証済みとして保存
    if device.verify_with_agent!(request.user_agent)
      cookies[:device_token] = {
        value: device.device_token,
        expires: 1.month.from_now,
        httponly: true
      }
      clear_auth_session_data
    end
  end

  def complete_auth_flow(resource, confirmation_token: nil)
    clear_auth_session_data(confirmation_token: nil)
    persist_session_on_failure(resource)
  end

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
