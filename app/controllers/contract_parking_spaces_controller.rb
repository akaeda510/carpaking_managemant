class ContractParkingSpacesController < ApplicationController
  before_action :set_contractor
  before_action :authenticate_parking_manager!
  before_action :set_parking_lot, only: %i[new create]
  before_action :set_contract_parking_space, only: %i[update destroy]

  def new
    if @parking_lot.nil?
      redirect_to parking_lots_path, alert: "先に駐車場を登録してください" and return
    end

    @contract_parking_space = @contractor.contract_parking_spaces.build.decorate
  end

  def create
    @contract_parking_space = @contractor.contract_parking_spaces.build(contract_parking_space_params)
    # 契約者の登録管理者IDを記録
    @contract_parking_space.parking_manager_id = current_parking_manager.id

    authorize @contract_parking_space

    if @contract_parking_space.save
      redirect_to contractor_contract_parking_spaces_path(contractor), notice: "契約を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    autohorize @contract_parking_space
    if @contract_parking_space.update(contract_parking_space_params)
      redirect_to contractor_path(@contractor), "契約を更新しました"
    else
      redirect_back fallback_location: root_path, alert: @contractor_parking_space.errors.full_messeges.join(", ")
    end
  end

  def index
    @contractor = @contractor.decorate
    @contract_parking_spaces = @contractor.contract_parking_spaces.includes(:parking_space).decorate
  end

  def destroy
    contractor_id = @contract_parking_space.contractor_id
    if @contract_parking_space.destroy
      redirect_to contractor_path(contractor_id), notice: "契約を削除されました"
    else
      redirect_to contractor_path(contractor_id), notice: "契約の削除に失敗しました"
    end
  end

  private

  def set_parking_lot
    @parking_lots = current_parking_manager.parking_lots
    @parking_lot = @parking_lots.find_by_id_or_first(params[:parking_lot_id])
  end

  def set_contractor
    @contractor = current_parking_manager.contractors.find(params[:contractor_id]).decorate
  end

  def contract_parking_space_params
    params.require(:contract_parking_space).permit(
      :start_date, :end_date, :contractor_id, :parking_space_id
    )
  end

  def set_contract_parking_spece
    @contract_parking_space = @contractor.contract_parking_spaces.find(params[:id])
  end
end
