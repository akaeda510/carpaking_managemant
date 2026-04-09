class ParkingManagersController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :enforce_device_verification

  def show
    @parking_manager = current_parking_manager.decorate
    authorize @parking_manager
  end
end
