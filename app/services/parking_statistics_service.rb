class  ParkingStatisticsService
 
  def initialize(parking_manager, scope = nil)
    @parking_manager = parking_manager
    @scope = scope
  end

  def parking_spaces
    case @scope
    when nil
      @parking_manager.parking_spaces
    when ParkingLot, ParkingArea
      @scope.parking_spaces
    end
  end

  def status_counts
    parking_spaces.group(:status).count
  end

  def monthly_sales
    today = Date.today
    start_period = 5.months.ago.to_date

    ContractParkingSpace
      .joins(:parking_space)
      .where(parking_manager_id: @parking_manager.id)
      .group_by_month(:start_date, range: start_period..today)
      .sum("parking_spaces.price")
  end
end
