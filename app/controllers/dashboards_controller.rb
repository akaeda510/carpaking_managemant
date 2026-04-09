class DashboardsController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :enforce_device_verification

  def show
    authorize :dashboard
    @parking_manager = current_parking_manager
  end
end
