class Admin::ParkingManagersController < Admin::BaseController
  def index
    authorize [ :admin, ParkingManager ]
    parking_managers = ParkingManager.all.includes(:parking_lots)
    if params[:query].present?
      parking_managers = parking_managers.search_full_text(params[:query]).reorder(created_at: :desc)
    else
      parking_managers = parking_managers.order(created_at: :desc)
    end

    @parking_managers = parking_managers.decorate
  end

  def show
    @parking_manager = ParkingManager.find(params[:id]).decorate
    authorize [ :admin, ParkingManager ]
    @parking_lots = @parking_manager.parking_lots.includes(:contract_parking_spaces)
  end
end
