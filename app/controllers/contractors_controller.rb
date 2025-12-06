class ContractorsController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :set_contractors, only: %i[index]
  before_action :set_contractor, only: %i[edit update]

  def new
    @contractor = Contractor.new
  end

  def create
    @contractor = current_parking_manager.contractor.build(contractor_params)
    if @contractor.save
      redirect_to contractors_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index; end

  def edit; end

  def update
    if @contractor.update(contractor_params)
      redirect_to contractors_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def contractor_params
    params.require(:contractor).permit(
      :first_name, :last_name, :prefecture, :city, :street_address,
      :buildint, :phone_number, :contact_number, :notes,
      :contract_start_date, :contract_end_date
    )
  end

  def set_contractor
    @contractor = current_parking_manager.contractor.find(params[:id])
  end

  def set_contractors
    @contractors = current_parking_manager.contractor.all
  end
end
