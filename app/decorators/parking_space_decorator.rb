class ParkingSpaceDecorator < Draper::Decorator
  delegate_all

  def status_badge
    h.content_tag :span, status_i18n, class: "inline-flex items-center px-2 py-0.5 rounded text-xs font-medium border #{status_color_class}"
  end

  def activity_log_config
    case @parking_space.status
    when "contracted"
      { label: "契約中", icon: "check_circle", color: "bg-green-50 text-green-700" }
    when "available"
      { label: "空き区画", icon: "person_remove", color: "bg-blue-50 text-blue-700" }
    when "pending"
      { label: "契約予約", icon: "pending_actions", color: "bg-yellow-50 text-yellow-700" }
    when "prohibited"
      { label: "使用不可", icon: "block", color: "bg-red-50 text-red-700" }
    else
      { label: "ステータス更新", icon: "sync", color: "bg-gray-50 text-gray-700" }
    end
  end

  def activity_detail
    "No.#{@parking_space.name}"
  end

  private

  def status_color_class
    case status
    when "available"  then "bg-blue-50 text-blue-700 border-blue-200"
    when "contracted" then "bg-green-50 text-green-700 border-green-200"
    when "pending"    then "bg-yellow-50 text-yellow-700 border-yellow-200"
    when "prohibited" then "bg-red-50 text-red-700 border-red-200"
    else "bg-gray-50 text-gray-700 border-gray-200"
    end
  end
end
