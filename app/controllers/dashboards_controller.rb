class DashboardsController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :enforce_device_verification

  def show
    authorize :dashboard

    @parking_manager = current_parking_manager
    @parking_lot = @parking_manager.parking_lots.first
    raw_items = @parking_manager.contractors.order(created_at: :desc).limit(5) + @parking_manager.parking_spaces.order(created_at: :desc).limit(5)
    
    # 契約スペース数
    @contracted_count = @parking_lot.parking_spaces.contracted.count
   # 契約しているスペース数 
    @available_count = @parking_lot.parking_spaces.available.count
    # 総スペース数
    @total_capacity = @parking_lot.parking_spaces.count
    # 稼働率
    @occupancy_rate = @total_capacity.positive? ? (@contracted_count.to_f / @total_capacity * 100).round(1) : 0
    # 月間収益
    @monthly_revenue = @parking_lot.parking_spaces.contracted.sum(:price)
    # 有効契約数
    @active_tenants_count = @parking_lot.contract_parking_spaces.active.count
    # 操作ログ
    @activities = raw_items.map(&:to_activity).sort_by { |log| log[:occurred_at] }.reverse.first(5)
    # 稼働率グラフ
    # @monthly_stats = nil
  end
end
