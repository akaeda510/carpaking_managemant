class Admin::ParkingManagersController < Admin::BaseController
  def index
    @parking_managers = ParkingManager.all.includes(:parking_lots).order(created_at: :desc).decorate
  end

  def show
    @parking_manager = ParkingManager.find(params[:id])
    @parking_lots = @parking_manager.parking_lots.includes(:contract_parking_spaces).decorate
  end
end
