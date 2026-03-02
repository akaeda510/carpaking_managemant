class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!
  layout "admin"

  include Pundit::Authorization

  def pundit_user
    current_admin
  end

  def current_admin
    @current_admin ||= ::Admin.find_by(id: session[:admin_id]) if session[:admin_id]
  end
  helper_method :current_admin

  private

  def authenticate_admin!
    if current_admin.nil?
      redirect_to admin_login_path, success: "管理者のログインが必要です"
    end
  end
end
