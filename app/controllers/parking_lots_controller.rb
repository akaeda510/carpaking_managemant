class ParkingLotsController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :set_parking_lot, only: %i[show edit update destroy]
  before_action :set_parking_lots, only: %i[index]
  before_action :authorize_parking_lot, only: %i[show edit update destroy]

  def new
    @parking_lot = ParkingLot.new
  end

  def create
    @parking_lot = current_parking_manager.parking_lots.build(parking_lot_params)
    authorize @parking_lot

    if @parking_lot.save
      redirect_to parking_lots_path, seccess: "駐車エリア #{@parking_lot.mane} が作成されました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def index;  end

  def edit; end

  def update
    if @parking_lot.update(parking_lot_params)
      redirect_to parking_lots_path, seccess: "駐車エリア#{@parking_lot.mane} が更新されました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @parking_lot.destroy!
    flash[:seccess] = "駐車エリア #{@parking_lot.mane} が削除されました"
    redirect_to parking_lot_path, status: :see_other
  end

  private

  def parking_lot_params
    params.require(:parking_lot).permit(:name, :prefecture, :city, :street_address, :description, :total_spaces)
  end

  def set_parking_lot
    @parking_lot = current_parking_manager.parking_lots.find(params[:id])
  end

  def set_parking_lots
    @parking_lots = current_parking_manager.parking_lots.all.order(name: :DESC)
  end

  def authorize_parking_lot
    authorize(@parking_lot)
  end
end
