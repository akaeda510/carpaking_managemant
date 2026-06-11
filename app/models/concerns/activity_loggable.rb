module ActivityLoggable
  extend ActiveSupport::Concern

  def to_activity
    decorator_name = "#{self.class.name}Decorator"

    if Object.const_defined?(decorator_name)
      decorator = decorator_name.constantize.new(self)
      config = decorator.activity_log_config

    {
      title: config[:label],
      detail: decorator.activity_detail,
      occurred_at: updated_at,
      icon: config[:icon],
      color_class: config[:color]
    }
    else
      if Rails.env.development?
        rails NameError, "#{decorator_nhame} が見つかりません。作成してください。"
      else
        { title: "通知", detail: "データが更新されました。", occurrend_at: updated_at }
      end
    end
  end
end
