class ParkingSpacesController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :set_parking_lot
  before_action :set_parking_space, only: %i[show edit update destroy]
  before_action :authorize, only: %i[show edit update destroy]

  def new
    @parking_space = @parking_lot.parking_spaces.build
  end

  def create
    @parking_space = @parking_lot.parking_spaces.build(parking_space_params)
    @parking_space.parking_manager_id = current_parking_manager.id

    authorize @parking_space

    if @parking_space.save
      redirect_to parking_lot_parking_spaces_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @parking_spaces = @parking_lot.parking_spaces.all.order(id: :DESC)
  end

  def show; end

  def edit; end

  def update
    if @parking_space.update(parking_space_params)
      redirect_to [ @parking_lot, @parking_space ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @parking_space.destroy!
    redirect_to parking_lot_parking_spaces_path(@parking_lot), status: :see_other
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

  def authorize_parking_space
    authorize(@parking_space)
  end
end
