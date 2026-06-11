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

  # 総スペース数
  def total_capacity
    parking_spaces.count
  end

  # 契約ずみスペース
  def contracted_count
    parking_spaces.contracted.count
  end

  # 空きスペース数
  def available_count
    parking_spaces.available.count
  end

  # 月間収益
  def monthly_revenue
    parking_spaces.contracted.sum(:price)
  end

  # 有効契約数
  def active_tenants_count
    parking_spaces
      .joins(:contract_parking_spaces)
      .merge(ContractParkingSpace.active)
      .count
  end

  # 稼働率
  def occupancy_rate
    total_capacity.positive? ?
      (contracted_count.to_f / total_capacity * 100).round(1) : 0
  end
end
