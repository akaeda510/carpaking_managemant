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

  def action_button(type, url, options = {})
    config = case type
    when :show
               { label: "詳細", icon: "fa-eye", base_class: "bg-white border-gray-200 text-gray-600 hover:bg-gray-50" }
    when :edit
               { label: "編集", icon: "fa-pen-to-square", base_class: "bg-indigo-50 text-indigo-600 hover:bg-indigo-100" }
    when :delete
               { label: "削除", icon: "fa-trash-can", base_class: "bg-red-50 text-red-600 hover:bg-red-100",
                 data: { turbo_method: :delete, turbo_confirm: options[:confirm] || "本当に削除しますか？" } }
    end

    common_class = "flex-1 lg:flex-none text-center px-3 py-1.5 rounded-lg text-xs font-bold transition shadow-sm active:scale-95"

    link_to url, class: "#{common_class} #{config[:base_class]}", data: config[:data] do
      concat content_tag(:i, "", class: "fa-solid #{config[:icon]} mr-1.5") if options[:with_icon]
      concat config[:label]
    end
  end

  # パスワード可視化アイコン
  def password_toggle_button(target_id)
    content_tag :button, type: 'button',
                class: 'p-2 text-gray-400 hover:text-indigo-600 transition-colors focus:outline-none',
                data: { password_toggle_target: target_id } do
      tag.svg(xmlns: "http://www.w3.org/2000/svg", class: "h-6 w-6", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor") do
        tag.path(stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M15 12a3 3 0 11-6 0 3 3 0 016 0z") +
        tag.path(stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z")
      end
    end
  end
end
