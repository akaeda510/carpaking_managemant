class Admin::DashboardsController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'

  def show
    @current_admin_id = current_admin.id
  end
end
