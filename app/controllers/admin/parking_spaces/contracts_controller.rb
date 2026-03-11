class Admin::ParkingSpaces::ContractsController < Admin::BaseController
  before_action :set_parking_space
  before_action :set_parking_area
  before_action :set_parking_lot

  def index
    @contracts = @parking_space.contract_parking_spaces.order(start_date: :desc)
  end

  private

  def set_parking_lot
    @parking_lot = @parking_area.parking_lot
  end

  def set_parking_area
    @parking_area = @parking_space.parking_area
  end

  def set_parking_space
    @parking_space = current_admin.parking_spaces.find(params[:parking_space_id])
  end
end
