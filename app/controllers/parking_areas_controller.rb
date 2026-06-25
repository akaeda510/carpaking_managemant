class ParkingAreasController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :enforce_device_verification
  before_action :set_parking_lot
  before_action :set_parking_area, only: %i[ edit update destroy ]

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
      redirect_to parking_lot_parking_areas_path(@parking_lot), success: "エリアを作成しました。", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @parking_areas = @parking_lot.parking_areas.order(:name)
  end

  def edit; end

  def update
    if @parking_area.update(parking_area_params)
      redirect_to parking_lot_parking_areas_path(@parking_lot), success: "エリアが更新されました。", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @parking_area.destroy!
      flash[:success] = "#{@parking_area.name} が削除されました"
      redirect_to parking_lot_parking_areas_path(@parking_lot), status: :see_other

    rescue ActiveRecord::DeleteRestrictionError
      flash[:alert] = "この駐車場には契約中の駐車スペースがあるため、削除することができません"
      redirect_to parking_lot_parking_areas_path(@parking_lot), status: :see_other

    rescue => e
      logger.error "駐車場削除エラー: #{e.message}"
      flash[:alert] = "システムエラーが発生したため削除できませんでした"
      redirect_to parking_lot_parking_area_path(@parking_lot), status: :see_other
    end
  end

    private

    def parking_area_params
      params.require(:parking_area).permit(:name, :default_price, :category, :description)
    end

    def set_parking_lot
      @parking_lot = current_parking_manager.parking_lots.find(params[:parking_lot_id])
    end

    def set_parking_area
      @parking_area = @parking_lot.parking_areas.find(params[:id])
    end
  end
