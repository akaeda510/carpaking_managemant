class Admin::ParkingManagersController < Admin::BaseController
  def contractors
    @parking_manager = ParkingManager.find(params[:id])
    @contractors = ParkingManager
      .joins(contract_parking_spaces: :parking_lot)
      .where(parking_lots: { parking_manager_id: parking_manager.id })
      .distince
  end
end
