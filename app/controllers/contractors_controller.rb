class ContractorsController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :set_contractors, only: %i[index]

  def new
    @contractor = Contractor.new
  end

  def create
    @contractor = current.parking_manager.contractor.build(contractor_params)
    if @contractor.save
      redirect_to contractors_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index; end

  private

  def contractor_params
    params.require(:contractor).permit(
      :first_name, :last_name, :prefecture, :city, :street_address,
      :buildint, :phone_number, :contact_number
    )
  end

  def set_contractors
    @contractors = current_parking_manager.contractor.all
  end
end
