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

  def back_link_button(label, path, **options)
    classes = "btn-secondary inline-flex items-center #{options[:class]}"

    link_to path, options.merge(class: classes) do
      concat tag.svg(
        tag.path(
          fill_rule: "evenodd",
          d: "M17 10a.75.75 0 01-.75.75H5.612l4.158 3.96a.75.75 0 11-1.04 1.08l-5.5-5.25a.75.75 0 010-1.08l5.5-5.25a.75.75 0 111.04 1.08L5.612 9.25H16.25A.75.75 0 0117 10z",
          clip_rule: "evenodd"
        ),
        class: "-ml-1 mr-2 h-5 w-5 text-gray-400",
        xmlns: "http://www.w3.org/2000/svg",
        viewBox: "0 0 20 20",
        fill: "currentColor"
      )
      concat label
    end
  end
end
