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

  def monthly_occupancy_rate
    today = Date.today
    start_period = 5.months.ago.to_date
    total = parking_spaces.count

    monthly_contracts = ContractParkingSpace
      .joins(:parking_space)
      .where(parking_manager_id: @parking_manager.id)
      .group_by_month(:start_date, range: start_period..today.end_of_day)
      .count

    monthly_contracts.transform_values do |count|
      total.positive? ? (count.to_f / total * 100).round(1) : 0
    end
  end
end
