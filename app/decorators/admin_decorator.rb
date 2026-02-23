class AdminDecorator < Draper::Decorator
  delegate_all

  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def phone_number
    object.phone_number.to_s.gsub(/(\d{3})(\d{4})(\d{4})/, '\1-\2-\3')
  end
end
