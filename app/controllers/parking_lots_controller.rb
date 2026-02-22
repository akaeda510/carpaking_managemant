class ParkingLotsController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :set_parking_lot, only: %i[show edit update destroy]
  before_action :set_parking_lots, only: %i[index]

  def new
    authorize ParkingLot
    @parking_lot = ParkingLot.new
  end

  def create
    @parking_lot = current_parking_manager.parking_lots.build(parking_lot_params)
    authorize @parking_lot

    if @parking_lot.save
      redirect_to parking_lots_path, success: "駐車エリア #{@parking_lot.name} が作成されました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    authorize @parking_lot
  end

  def index
    authorize ParkingLot
    @parking_lots = policy_scope(ParkingLot)
    @parking_lot = @parking_lots.decorate
  end

  def edit
    authorize @parking_lot
  end

  def update
    authorize @parking_lot
    if @parking_lot.update(parking_lot_params)
      redirect_to parking_lots_path, success: "#{@parking_lot.name} が更新されました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @parking_lot
    begin
    @parking_lot.destroy!
    flash[:success] = "#{@parking_lot.name} が削除されました"
    redirect_to parking_lot_path, status: :see_other

    rescue ActiveRecord::DeleteRestrictionError
      flash[:alert] = "この駐車場には契約中の駐車スペースがあるため、削除することができません"
      redirect_to parking_lot_path(@parking_lot), status: :see_other

    rescue => e
      logger.error "駐車場削除エラー: #{e.message}"
      flash[:alert] = "システムエラーが発生したため削除できませんでした"
      redirect_to parking_lot_path(@parking_lot), status: :see_other
    end
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
end
