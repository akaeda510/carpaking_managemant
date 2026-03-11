class Admin::ParkingAreasController < Admin::BaseController
  before_action :set_parking_area, only: %i[ show ]
  before_action :set_parking_lot


  def show
    @available_count = @parking_area.parking_spaces.available.count
    @parking_spaces = ParkingSpaceDecorator.decorate_collection(@parking_area.parking_spaces.sort_by_natural_name)
  end

  private

  def set_parking_lot
    @parking_lot = @parking_area.parking_lot
  end

  def set_parking_area
    @parking_area = current_admin.parking_areas.find(params[:id])
  end
end
