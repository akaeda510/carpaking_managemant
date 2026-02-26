class Admin::DashboardsController < Admin::BaseController
  def show
    @current_admin_id = current_admin.id
  end
end
