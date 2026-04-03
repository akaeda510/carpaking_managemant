# frozen_string_literal: true

class ParkingManagers::PasswordsController < Devise::PasswordsController
  prepend_before_action :authenticate_parking_manager!, only: %i[ new create ], if: -> { parking_manager_signed_in? }
  skip_before_action :require_no_authentication, only: %i[ new create edit ]
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

      if parking_manager_signed_in?
        respond_with resource, location: after_sign_in_path_for(resource)
      else
        respond_with resource, location: new_parking_manager_session_path
      end
    else
      respond_with(resource)
    end
  end

  def edit
    # パスワードリセット後、トークンを失効し、独自のパスを指定
    resource = resource_class.with_reset_password_token(params[:reset_password_token])

    unless resource&& resource.reset_password_period_balid?
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
    super do |resource|
      if resource.errors.empty?
        register_and_verify_current_device(resource)


        if parking_manager_signed_in?
          set_flash_message! :notice, :updated
          bypass_sign_in(resource)
          respond_with resource, location: after_sign_in_path_for(resource)
        else
          set_flash_message! :notice, :updated_not_active
          respond_with resource, location: new_parking_manager_session_path
        end
        return
      end
    end
  end

  protected

  def register_and_verify_current_device(resource)
    device = Devices.find_or_initialize_by(resource, cookies[:device_token])

    # デバイスの検証済みとして保存
    if device.verify_with_agent!(request.user_agent)
      cookies[:device_token] = {
        value: device.device_token,
        expires: 1.month.from_now,
        httponly: true
      }

      session.delete(:need_verification)
      session.delete(:pending_device_id)
    end
  end

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
