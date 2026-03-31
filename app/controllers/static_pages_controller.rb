class StaticPagesController < ApplicationController
  skip_before_action :authenticate_parking_manager!
  skip_before_action :confirm_device_verified!

  def privacy; end

  def settings; end
end
