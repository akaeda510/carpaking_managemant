class ParkingManagers::SettingsController < ApplicationController

  def index
    authorize :parking_manager, :index?
  end
  
end
