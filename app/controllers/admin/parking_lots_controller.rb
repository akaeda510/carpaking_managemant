class Admin::ParkingLotsController < Admin::BaseController
  before_action :set_parking_lot, only: %i[ show ]

  def index
    @parking_lots = current_admin.parking_lots.includes(:parking_areas).order(created_at: :desc)
  end

  def show
    @parking_areas = @parking_lot.parking_areas.includes(:parking_spaces).order(:name)
  end

  private

  def set_parking_lot
    @parking_lot = current_admin.parking_lots.find(params[:id])
  end
end
