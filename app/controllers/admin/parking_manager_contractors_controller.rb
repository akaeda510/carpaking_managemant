class Admin::ParkingManagerContractorsController < Admin::BaseController
  def contractors
    @parking_manager = ParkingManager.find(params[:id])
    @contractors = @parking_manager.contractors.distinct.decorate
  end
end
