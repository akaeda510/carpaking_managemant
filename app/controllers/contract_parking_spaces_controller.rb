class ContractParkingSpacesController < ApplicationController
  before_action :set_contractor
  before_action :set_parking_lot
  before_action :authenticate_parking_manager!
  before_action :set_contract_parking_space, only: %i[update destroy]
  before_action :authorize_contract_parking_space, only: %i[update destroy]

  def create
    @contract_parking_space = ContractParkingSpace.new(contract_parking_space_params)
    # 契約者の登録管理者IDを記録
    @contract_parking_space.parking_manager_id = current_parking_manager.id

    authorize @contract_parking_space

    if @contract_parking_space.save
      redirect_to contractor_path(@contract_parking_space.contractor_id)
    else
      redirect_back fallback_location: root_path, alert: @contractor_parking_space.errors.full_messeges.join(", ")
    end
  end

  def show; end

  def edit; end

  def update
    if @contract_parking_space.update(contract_parking_space_params)
      redirect_to contractor_path(@contract_parking_space.contractor_id)
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
    @parking_lot = current_parking_manager.parking_lots.find_by(id: params[:parking_lot_id])
  end

  def set_contractor
    @contractor = current_parking_manager.contractors.find(params[:contractor_id])
  end

  def contrart_parking_space_params
    params.require(:contract_parking_space).permit(
      :start_date, :end_date, :contractor_id, :parking_space_id
    )
  end

  def set_contract_parking_spece
    @contract_parking_space = current_parking_manager.parking_lot.find_by(params[:id])
  end

  def authorize_contract_parking_space
    authorize(@contract_parking_space)
  end
end
