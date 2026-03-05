class ParkingAreasController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :set_parking_lot

  def index
    @parking_areas = @parking_lot.parking_areas.order(:created_at)
  end

  private

  def parking_area_params
    params.require(:parking_area).permit(:name, :default_price)
  end

  def set_parking_lot
    @parking_lot = current_parking_manager.parking_lots.find(params[:parking_lot_id])
  end
end
