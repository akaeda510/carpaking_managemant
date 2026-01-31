class ParkingManagerDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  def formatted_created_at
    object.created_at.strftime("%Y年%m月%d日")
  end

  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def phone_number
    object.phone_number.to_s.gsub(/(\d{3})(\d{4})(\d{4})/, '\1-\2-\3')
  end

  def contact_number
    object.contact_number.to_s.gsub(/(\d{2,5})(\d{1,4})(\d{4})/, '\1-\2-\3')
  end

  def address
    "#{object.prefecture} #{object.city} #{object.street_address}"
  end
end
