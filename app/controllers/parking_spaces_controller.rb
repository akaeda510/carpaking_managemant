class ParkingSpacesController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :set_parking_lot

  def new
    @parking_space = @parking_lot.parking_spaces.build
  end

  def create
    @parking_space = @parking_lot.parking_spaces.build(parking_space_params)
    @parking_space.parking_manager_id = current_parking_manager.id

    if @parking_space.save
      redirect_to parking_lot_parking_spaces_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @parking_spaces = @parking_lot.parking_spaces.all.order(id: :DESC)
  end

  private

  def parking_space_params
    params.require(:parking_space).permit(:name, :width, :length, :description)
  end

  def set_parking_space
    @parking_space = @parking_lot.parking_spaces.find(params[:id])
  end

  def set_parking_lot
    @parking_lot = ParkingLot.find(params[:parking_lot_id])
  end
end
