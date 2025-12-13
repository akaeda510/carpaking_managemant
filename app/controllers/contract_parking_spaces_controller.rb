class ContractParkingSpacesController < ApplicationController
  before_action :authenticate_parking_manager!

  def new
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def contract_parking_space_params
    params.require(:contract_parking_space).permit(:start_date, :end_date)
  end

  def authorize_contract_parking_space
    authorize(@contract_parking_space)
  end
end
