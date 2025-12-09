class DashboardsController < ApplicationController
  before_action :authenticate_parking_manager!

  def show
    authorize :dashboard
    @parking_manager = current_parking_manager
  end
end
