class ContractorsController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :set_contractors, only: %i[index]
  before_action :set_contractor, only: %i[show edit update destroy]
  before_action :authorize_contract, only: %i[show edit update destroy]

  def new
    @contractor = Contractor.new
  end

  def create
    @contractor = current_parking_manager.contractor.build(contractor_params)
    authorize @contractor

    if @contractor.save
      redirect_to contractors_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def index; end

  def edit; end

  def update
    new_parking_space_id = contractor_params[:parking_space_id]
    new_start_date = contractor_params[:start_date]

    ActiveRecord::Base.transaction do
 
      if @contractor.update(contractor_params.except(:parking_space_id, :start_date))
        # 既存の契約を終了する場合
        if should_end_contract || end_date_input.present?
          # 契約者が持つすべての有効な契約を取得
          @contractor.active_contractor_parking_space.each do |contract|
            contract_to_end.update!(end_date: Date.current)
          end
        end
        # 新しい契約を作成
        if new_parking_space_id.present?
          ContractParkingSpace.create!(
            parking_space_id = new_parking_space.id,
            contractor_id = @contractor.id
            start_date = new_start_date,
            end_date = ACTIVE_CONTRACT_END_DATE
          )
        end
      redirect_to contractors_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @contractor.destroy!
      redirect_to contractors_path, status: :see_other
  end

  private

  def contractor_params
    params.require(:contractor).permit(
      :first_name, :last_name, :prefecture, :city, :street_address,
      :buildint, :phone_number, :contact_number, :notes,
      )
  end

  def set_contractor
    @contractor = current_parking_manager.contractor.find(params[:id])
  end

  def set_contractors
    @contractors = current_parking_manager.contractor.all
  end

  def authorize_contract
    authorize(@contractor)
  end
end
