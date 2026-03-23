class DeviceDecorator < Draper::Decorator
  delegate_all

  def login_timestamp
    object.last_login_at.strftime("%Y-%m-%d %H:%M:%S")
  end

  def friendly_name(remote_ip)
    Device.generate_friendly_name(object.user_agent, remote_ip)
  end
end
