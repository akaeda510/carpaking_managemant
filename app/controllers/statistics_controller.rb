class StatisticsController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :enforce_device_verification

  def index
    @parking_manager = current_parking_manager

    stats = ParkingStatisticsService.new(@parking_manager, nil)

    @status_counts = stats.status_counts
    @monthly_sales = stats.monthly_sales
  end
end
