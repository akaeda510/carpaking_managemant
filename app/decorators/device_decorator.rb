class DeviceDecorator < Draper::Decorator
  delegate_all

  def login_timestamp
    object.last_login_at.strftime("%Y-%m-%d %H:%M:%S")
  end

  def friendly_name(remote_ip)
    location = Geocoder.search(remote_ip).first
    city_info = location&.city.present? ? "#{location.city}付近の" : "不明な場所の"

    device_label = Device.set_name_by_user_agent(device.user_agent, nil)

    "#{city_info}#{device_label}"
  end
end
