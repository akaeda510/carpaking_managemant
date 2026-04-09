class ParkingManagers::SettingsController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :enforce_device_verification

  def index
    authorize :parking_manager, :index?
    render :index, locals: { partial_name: "top_setting" }
  end

  def account
    @parking_manager = current_parking_manager
    render :index, locals: { partial_name: "account_setting" }
  end
end
