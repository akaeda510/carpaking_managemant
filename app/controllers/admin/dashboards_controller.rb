class Admin::DashboardsController < Admin::BaseController
  def index
    authorize @admin
    @current_admin_id = current_admin.id
  end
end
