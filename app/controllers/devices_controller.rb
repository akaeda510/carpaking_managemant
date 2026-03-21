class DevicesController < ApplicationController
  skip_before_action :authenticate_parking_manager!, only: [:verify]

  def verify
    @device = Device.find_by!(device_token: params[:id])

    if @device.expires_at < Time.current
      redirect_to new_parking_manager_session_path, alert: "登録期限が切れています。再度ログインをしてください。"
      return
    end

    if @device.update(is_verified: true)
      @redirect_path = parking_manager_signed_in? ? root_path: new_parking_manager_session_path
    else
      redirect_to new_parking_manager_session_path, alert: "登録に失敗しました。"
    end
  end

  def resend_email
    @device = Device.find(params[:id])
    ParkingMangers::DeviceMailer.warning_new_device_login(current_parking_manager, @device).deliver_later

    redurect_to wait_verification_path, seccess: "端末登録メールを再送しました"
  end
end
