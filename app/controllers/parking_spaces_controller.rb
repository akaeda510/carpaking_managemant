class ParkingSpacesController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :set_parking_lot
  before_action :set_parking_space, only: %i[show edit update destroy]
  before_action :authorize_parking_space, only: %i[show edit update destroy]

  def new
    @parking_space = @parking_lot.parking_spaces.build
    @parking_space.build_garage_detail
  end

  def create
    @parking_space = @parking_lot.parking_spaces.build(parking_space_params)
    @parking_space.parking_manager_id = current_parking_manager.id

    authorize @parking_space

    if @parking_space.save
      redirect_to parking_lot_parking_spaces_path, success: "駐車スペース #{@parking_space.name} が作成されました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @parking_spaces = @parking_lot.parking_spaces.all.order(id: :DESC)
  end

  def show; end

  def edit
    @parking_space.build_garage_detail unless @parking_space.garage_detail
  end

  def update
    new_contractor_id = parking_space_params[:contractor_id]
    new_start_date = parking_space_params[:start_date]

    ActiveRecord::Base.transaction do
      if @parking_space.update(parking_space_params.except(:contractor_id, :start_date))
        # 契約者が変更、または新しく設定された場合
        if new_contractor_id.present? && new_contractor_id.to_i != @parking_space.current_contractor_id
          # 既存の有効な契約を終了させる
          @parking_space.current_contractors_space&.update(end_date: Date.yestarday)
          # 新たに中間テーブルのレコードを作成
          ContractorParkingSpace.create!(
            parking_space_id: @parking_space.id,
            contractor_id: new_contractor_id,
            start_date: new_start_date,
            end_date: ACTIVE_CONTRACT_END_DATE
          )
        end

        flash[:success] = "#{@parking_space.name} が更新されました"
        redirect_to [ @parking_lot, @parking_space ]
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    begin
    @parking_space.destroy!
    flash[:success] = "#{@parking_space.name} が削除されました"
    redirect_to parking_lot_parking_spaces_path(@parking_lot), status: :see_other

    rescue ActiveRecord::DeleteRestrictionError
      flash[:alert] = "この駐車場は契約状態のため、削除することができません"
      redirect_to [ @parking_lot, @parking_space ], status: :see_other

    rescue => e
      logger.error "駐車スペース削除エラー: #{e.message}"
      flash[:alert] = "システムエラーが発生したため削除できませんでし
た"
      redirect_to parking_lot_parking_spaces_path(@parking_lot), status: :see_other
    end
  end

  private

  def parking_space_params
    params.require(:parking_space).permit(:name, :width, :length, :description, :parking_typei, garage_detail_attributes: [:id, :height, :_destroy])
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
