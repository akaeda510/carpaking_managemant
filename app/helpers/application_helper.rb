module ApplicationHelper
  def tailwind_flash_classes(message_type)
    base_classed = "p-4 mb-4 text-sm rounded-lg"

    case message_type
    when :success
      # 成功(緑色)
      colot_classes = "bg-green-100 text-green-800 border-green-400 border"
      # 失敗(赤色)
    when :danger
      colot_classes = "bg-red-100 text-red-800 border-red-400 border"
      # 警告・注意(黄色)
    when :alert
      colot_classes = "bg-yellow-100 text-yellow-800 border-yellow-400 border"
    else
      # その他(情報、青色など)
      colot_classes = "bg-blue-100 text-blue-800 border-blue-400 border"
    end

    "#{base_classed} #{colot_classes}"
  end

  def back_link_to(label, path, **options)
    classes = "btn-secondary #{options[:class]}"

    link_to path, options.merge(class: classes) do
      concat tag.i(class: "fa-solid fa-arrow-left mr-2") if defined?(FontAwesome)
      concat label
    end
  end
end
