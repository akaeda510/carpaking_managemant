class DashboardsController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :enforce_device_verification

  def show
    authorize :dashboard

    @parking_manager = current_parking_manager
    @parking_lot = @parking_manager.parking_lots.first

    # デフォルト設定
    status = {
      contracted_count: 0, availabel: 0, total_capacity: 0,
      occupancy_rate: 0, monthly_revenue: 0,
      active_tenants_count: 0
    }

    if @parking_lot
      status = @parking_lot.dashboard_status
    end

    # 契約スペース数
    @contracted_count     = status[:contracted_count]
    # 契約しているスペース数
    @available_count      = status[:available_count]
    # 総スペース数
    @total_capacity       = status[:total_capacity]
    # 稼働率
    @occupancy_rate       = status[:occupancy_rate]
    # 月間収益
    @monthly_revenue      = status[:monthly_revenue]
    # 有効契約数
    @active_tenants_count = status[:active_renants_count]
    # 操作ログ
    @activities = @parking_lot ? fetch_activities : []
    # 稼働率グラフ
    # @monthly_stats = nil
  end

  private

  def fetch_activities
     raw_items = @parking_manager.contractors.order(created_at: :desc).limit(5) + @parking_lot.parking_spaces.order(created_at: :desc).limit(5)
     raw_items.map(&:to_activity).sort_by { |log| log[:occurred_at] }.reverse.first(5)
  end
end
