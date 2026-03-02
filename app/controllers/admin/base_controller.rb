class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!
  layout "admin"
  pundit_user :pundit_admin

  def pundit_admin
    current_admin
  end

  def current_admin
    @current_admin ||= ::Admin.find_by(id: session[:admin_id]) if session[:admin_id]
  end
  helper_method :current_admin

  private

  def authenticate_admin!
    if current_admin.nil?
      redirect_to admin_login_path, alert: "管理者のログインが必要です"
    end
  end
end
