class Admin::ParkingSpacesController < Admin::BaseController
  before_action :set_parking_space, only: %i[ show ]
  before_action :set_parking_area
  before_action :set_parking_lot

  def show
    @current_contract = @parking_space.current_contract
    @garage_deteil = @parking_space.garage_detail
    @parking_space_options = @parking_space.parking_space_options
    @current_contract = @parking_space.current_contract
    @contract_histories = @parking_space.contract_parking_spaces.order(start_date: :desc)
  end

  private

  def set_parking_lot
    @parking_lot = @parking_area.parking_lot
  end

  def set_parking_area
    @parking_area = @parking_space.parking_area
  end

  def set_parking_space
    @parking_space = current_admin.parking_spaces.find(params[:id])
  end
end
