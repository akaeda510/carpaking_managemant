class DashboardsController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :enforce_device_verification

  def show
    authorize :dashboard

    @parking_manager = current_parking_manager
    @parking_lots = @parking_manager.parking_lots

    # デフォルト設定
    statuses = {
      contracted_count: 0, availabel: 0, total_capacity: 0,
      occupancy_rate: 0, monthly_revenue: 0,
      active_tenants_count: 0
    }

    statuses =  @parking_lots.any? ?
      @parking_lots.map { |lot| lot.dashboard_status } : []

    total_status = statuses.each_with_object(Hash.new(0)) do |s, sum|
      s.each { |key, value| sum[key] += value }
    end
    # 契約スペース数
    @contracted_count     = total_status[:contracted_count]
    # 契約しているスペース数
    @available_count      = total_status[:available_count]
    # 総スペース数
    @total_capacity       = total_status[:total_capacity]
    # 稼働率
    @occupancy_rate       = total_status[:occupancy_rate].positive? ?
      (total_status[:contracted_count].to_f / 
       total_status[:total_capacity] * 100).round(1) : 0
    # 月間収益
    @monthly_revenue      = total_status[:monthly_revenue]
    # 有効契約数
    @active_tenants_count = total_status[:active_tenants_count]
    # 操作ログ
    @activities = @parking_lots ? fetch_activities : []
    # 稼働率グラフ
    @monthly_stats = ParkingStatisticsService.new(@parking_manager, nil).monthly_occupancy_rate
  end

  private

  def fetch_activities
    raw_items = @parking_manager.contractors.order(created_at: :desc).limit(5) + @parking_manager.parking_spaces.order(created_at: :desc).limit(5)
     raw_items.map(&:to_activity).sort_by { |log| log[:occurred_at] }.reverse.first(5)
  end
end
