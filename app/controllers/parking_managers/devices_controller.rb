class ParkingManagers::DevicesController < ApplicationController
  skip_before_action :confirm_device_verified!, only: [ :resend_email, :verify ]
  skip_before_action :authenticate_parking_manager!, only: [ :verify, :resend_email ], raise: false

  def verify
    @device = Device.find_by(device_token: params[:device_token])

    # 端末登録リンクを2回押した時
    if @device.nil?
      redirect_to new_parking_manager_session_path, alert: "認証リンクが無効になっています。再度ログインしてください。"
      return
    end

    if @device.expires_at.present? && @device.expires_at < Time.current
      @device.update(device_token: nil)
      redirect_to new_parking_manager_session_path, alert: "登録期限が切れています。再度ログインをしてください。"
      return
    end

    if @device.verify!
      # ブラウザに1ヶ月有効トークンを保存
      cookies[:device_token] = {
        value: @device.device_token,
        expires: 1.month.from_now,
        httponly: true,
        path: "/"
      }

      render :verified_success
    else
      redirect_to new_parking_manager_session_path, alert: "登録に失敗しました。"
    end
  end

  def resend_email
    @device = Device.find(params[:id])
    parking_manager = @device.parking_manager

    if parking_manager.present?
      ParkingManagers::DeviceMailer.warning_new_device_login(parking_manager, @device).deliver_later
      redirect_to wait_verification_path, success: "端末登録メールを再送しました"
    else
      redirect_to new_parking_managger_session_path, alert: "有効なアカウントが見つかりませんでした。"
    end
  end
end
