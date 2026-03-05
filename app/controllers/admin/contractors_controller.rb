class Admin::ContractorsController < Admin::BaseController
  def index
    @contractors = Contractor.all.includes(:parking_lots).decorate
  end

  def show
    @contractor = Contractor.find(params[:id]).decorate
    @contract_details = @contractor.contract_parking_spaces.includes(parking_space: :parking_lot)
  end
end
