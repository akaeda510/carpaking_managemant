class Admin::SessionsController < Admin::BaseController
  skip_before_action :authenticate_admin!, only: %i[new create], raise: false
  skip_authorization_only :new, :create, :destroy

  def new; end

  def create
    admin = ::Admin.find_by(email: params[:email])
    if admin&.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to admin_root_path, success: "管理者としてログインしました"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to admin_login_path, success: "ログアウトしました", status: :see_other
  end
end
