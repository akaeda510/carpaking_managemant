class ContractParkingSpaceDecorator < Draper::Decorator
  delegate_all

  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def display_end_date
    return "未設定" if end_date.blank?
    return h.content_tag(:span, "無期限", class: "text-gray-400 italic") if end_date.to_s == '2999-12-31'

    # もし契約終了日が30日前になると赤文字に変更
    if model.expiring_soon?
      return h.content_tag(:span, class: "text-red-600 font-bold") do
        h.concat h.content_tag(:i, "", class: "fa-solid fa-triangle-exclamation mr-1")
        h.concat end_date.strftime("%Y/%m/%d")
      end
    end

    end_date.strftime("%Y/%m/%d")
  end
end
