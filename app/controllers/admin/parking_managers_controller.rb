class Admin::ParkingManagersController < Admin::BaseController
  def index
    authorize [ :admin, ParkingManager ]
    @parking_managers = ParkingManager.all.includes(:parking_lots).order(created_at: :desc).decorate
  end

  def show
    @parking_manager = ParkingManager.find(params[:id]).decorate
    authorize [ :admin, ParkingManager ]
    @parking_lots = @parking_manager.parking_lots.includes(:contract_parking_spaces)
  end
end
