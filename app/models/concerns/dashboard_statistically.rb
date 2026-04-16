module DashboardStatistically
  extend ActiveSupport::Concern

  def dashboard_status
    total = parking_spaces.count
    contracted = parking_spaces.contracted.count

    {
      contractes_count: contracted,
      available: parking_spaces.available.count,
      total_capacity: total,
      occupancy_rate: total.positive? ? (contracted.to_f / total * 100).round(1) :0,
      monthly_revenue: parking_spaces.contracted.sum(:price),
      active_tenants_count: contract_parking_spaces.active.count
    }
  end

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
