class DevicesController < ApplicationController
  def verify
    @device = Device.find_by!(device_token: params[:id])

    if @device.update(is_verified: true)
      redirect_to root_path, success: "端末「#{@device.name}」を承認しました。"
    else
      redirect_to root_path, alert: "承認に失敗しました。"
    end
  end
end
