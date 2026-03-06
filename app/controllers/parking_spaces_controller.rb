class ParkingSpacesController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :set_parking_lot
  before_action :set_parking_area
  before_action :set_parking_space, only: %i[show edit update destroy]

  def new
    authorize ParkingSpace
    @parking_space = @parking_area.parking_spaces.build
    @parking_space.build_garage_detail
    @parking_space.price = @parking_area.default_price
  end

  def create
    @parking_space = @parking_area.parking_spaces.build
    authorize @parking_space
    @batch_form = ParkingSpaceBatchForm.new(batch_params)

    if @batch_form.save

      redirect_to [@parking_lot, @parking_area, @parking_space], success: "駐車場所: #{@parking_space.name} が作成されました"

    else

      @parking_space.assign_attributes(parking_space_params)

      if @parking_area.category == "garage"
        @parking_space.garage_detail ||= @parking_space.build_garage_detail
      end

      @batch_form.errors.each do |error|
        @parking_space.errors.add(error.attribute, error.message)
      end

      render :new, status: :unprocessable_entity
    end
  end

  def index
    authorize ParkingSpace
    @parking_spaces = @parking_area.parking_spaces.decorate
  end

  def show
    authorize @parking_space
  end

  def edit
    parking_space_build_garage_detail
    authorize @parking_space
  end

  def update
    authorize @parking_space
    if @parking_space.update(parking_space_params)
      flash[:success] = "駐車場所: #{@parking_space.name} が更新されました"
      redirect_to [ @parking_lot, @parking_area, @parking_space ]
    else
      parking_space_build_garage_detail
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @parking_space
    begin
      @parking_space.destroy!
      flash[:success] = "#{@parking_space.name} が削除されました"
      redirect_to parking_lot_parking_area_parking_spaces_path(@parking_lot), status: :see_other

    rescue ActiveRecord::DeleteRestrictionError
      flash[:alert] = "この駐車場は契約状態のため、削除することができません"
      redirect_to [ @parking_lot, @parking_area, @parking_space ], status: :see_other

    rescue => e
      logger.error "駐車スペース削除エラー: #{e.message}"
      flash[:alert] = "システムエラーが発生したため削除できませんでし
た"
      redirect_to [@parking_lot, @parking_area, @parking_space], status: :see_other
    end
  end

  private

  def parking_space_params
    params.require(:parking_space).permit(
      :name, :price, :width, :length, :description,
      :parking_area_id, :status, 
      garage_detail_attributes: [ :id, :height, :_destroy ],      parking_space_option_ids: [])
  end

  def set_parking_space
    @parking_space = @parking_lot.parking_spaces.find(params[:id])
  end

  def set_parking_lot
    @parking_lot = current_parking_manager.parking_lots.find(params[:parking_lot_id])
  end

  def set_parking_area
    @parking_area = @parking_lot.parking_areas.find(params[:parking_area_id])
  end

  def parking_space_build_garage_detail
    @parking_space.build_garage_detail unless @parking_space.garage_detail
  end

  def batch_params
    batch_params = params.require(:parking_space).permit(
      :name, :price, :width, :length, :description, :status).merge( 
      parking_area_id: @parking_area.id,
      batch_count:     params[:batch_count],
    )
  end
end
