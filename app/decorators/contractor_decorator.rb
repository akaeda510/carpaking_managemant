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

  def activity_log_config
    if object.created_at == object.updated_at
      { label: "新規契約者登録", icon: "登録", color: "bg-purple-50 text-purple-600" }
    else
      { label: "契約者情報更新", icon: "更新", color: "bg-indigo-50 text-indigo-600" }
    end
  end

  def activity_detail
    "契約者名: #{full_name} 様"
  end
end
