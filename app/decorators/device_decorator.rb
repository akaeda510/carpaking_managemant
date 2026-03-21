class DeviceDecorator < Draper::Decorator
  delegate_all

  def login_timestamp
    object.last_login_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
