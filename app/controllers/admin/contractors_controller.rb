class Admin::ContractorsController < Admin::BaseController
  def index
    contractors = Contractor.all
    if params[:query].present?
      contractors = contractors.search_full_text(params[:query]).reorder(created_at: :desc)
    else
      contractors = contractors.order(created_at: :desc)
    end

    @contractors = contractors.includes(
    active_contract_parking_spaces: {
      parking_space: :parking_lot
    }
    ).decorate
  end

  def show
    @contractor = Contractor.find(params[:id]).decorate
    @contract_details = @contractor.contract_parking_spaces.includes(parking_space: :parking_lot)
  end
end
