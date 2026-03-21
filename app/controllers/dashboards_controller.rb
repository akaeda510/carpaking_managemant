class DashboardsController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :confirm_device_verified!

  def show
    authorize :dashboard
    @parking_manager = current_parking_manager
  end
end
