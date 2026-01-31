class ContractorDecorator < Draper::Decorator
  delegate_all

  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def phone_number
    object.phone_number.to_s.gsub(/(\d{3})(\d{4})(\d{4})/, '\1-\2-\3')
  end

  def contact_number
    object.contact_number.to_s.gsub(/(\d{2,4})(\d{2,4})(\d{4})/,  '\1-\2-\3')
  end

  def address
    "#{object.prefecture} #{object.city} #{object.street_address}"
  end
end
