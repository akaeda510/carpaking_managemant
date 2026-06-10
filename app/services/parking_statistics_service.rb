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
    total = parking_spaces.count

    (0..5).reverse_each.each_with_object({}) do |i, result|
      target = i.months.ago.beginning_of_month.to_date

    count = ContractParkingSpace
      .where(parking_manager_id: @parking_manager.id)
      .where("start_date <= ?", target.end_of_month)
      .where("end_date >= ?", target.beginning_of_month)
      .where("start_date != end_date")
      .count

    result[target] = total.positive? ?
      (count.to_f / total * 100).round(1) : 0
    end
  end
end
