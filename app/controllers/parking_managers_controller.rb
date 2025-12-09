class ParkingManagersController < ApplicationController
  before_action :authenticate_parking_manager!

  def show
    authorize @parking_manager
    @parking_manager = current_parking_manager
  end
end
