class Admin::DashboardsController < Admin::BaseController
  def index
    authorize [ :admin, :dashboard ], :index?
    @current_admin_id = current_admin.id
  end
end
