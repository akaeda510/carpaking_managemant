class ParkingManagersController < ApplicationController
  before_action :authenticate_parking_manager!

  def show
    @parking_manager = current_parking_manager.decorate
    authorize @parking_manager
  end
end
