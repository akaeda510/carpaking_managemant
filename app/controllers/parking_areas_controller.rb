class ParkingAreasController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :set_parking_lot

  def new
    @parking_area = @parking_lot.parking_areas.build(
      category: :asphalt,
      name: "アスファルトエリア",
      default_price: 5000
    )
  end

  def create
    @parking_area = @parking_lot.parking_areas.build(parking_area_params)
    if @parking_area.save
      redirect_to parking_lot_parking_areas_path(@parking_lot), seccess: "エリアを作成しました。", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

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
