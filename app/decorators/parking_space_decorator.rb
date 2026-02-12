class ParkingSpaceDecorator < Draper::Decorator
  delegate_all

  def status_badge
    h.content_tag :span, status_i18n, class: "inline-flex items-center px-2 py-0.5 rounded text-xs font-medium border #{status_color_class}"
  end

  private

  def status_color_class
    case status
    when 'available'  then 'bg-blue-50 text-blue-700 border-blue-200'
    when 'contracted' then 'bg-green-50 text-green-700 border-green-200'
    when 'pending'    then 'bg-yellow-50 text-yellow-700 border-yellow-200'
    when 'prohibited' then 'bg-red-50 text-red-700 border-red-200'
    else 'bg-gray-50 text-gray-700 border-gray-200'
    end
  end
end
