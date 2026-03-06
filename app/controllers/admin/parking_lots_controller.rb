class Admin::ParkingLotsController < Admin::BaseController

  def index
    @parking_lots = current_admin.parking_lots.includes(:parking_areas).order(created_at: :desc)
  end

  private

end
