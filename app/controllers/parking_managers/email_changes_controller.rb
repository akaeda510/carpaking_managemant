class ParkingManagers::EmailChangesController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :enforce_device_verification

  EmailChange = ParkingManagers::EmailChange
  def new 
    @email_change = EmailChange.new
  end

  def create
    @email_change = current_parking_manager.email_changes.build(email_change_params)

    if @email_change.save
      ParkingManagers::EmailChangeMailer.email_reset(@email_change, request.remote_ip).deliver_later
      redirect_to new_parking_managers_email_change_path, success: "メールアドレス変更申請メールが送信されました。"
    else
      render :new, status: :unprocessable_entity    
    end
  end

  def edit
    @email_change = current_parking_manager.email_changes.find_by!(token: params[:id])

    if @email_change.active?
      redirect_to new_parking_managers_email_change_path, alert: "有効期限が切れています。もう一度申請してください。"
    end
  end

  def update
    @email_change = current_parking_manager.email_changes.find_by!(token: params[:id])
    @email_change.assign_attributes(email_change_params)

    AcitiveRecord::Base.transaction do
      @email_change.update!(confirmed_at: Time.current)
      current_parking_manager.update!(email: @email_change.new_email)
    end

    #  ParkingManagers::EmailUpdateMailer.email_update(@new_email).deliver_later
    flash[:success] = "メールアドレスが更新されました。"
    redirect_to my_dashboard_root_path(@parking_manager), status: :see_other
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = "更新が失敗しました。入力を確認してください。"
    render :edit, status: :unprocessable_entity
  rescue => e
    logger.error "Email Update Error: #{e.message}"
    redirect_to new_parking_managers_email_change_path, alert: "予期せぬエラーが発生しました。"
  end


  private

  def email_change_params
    params.require(:email_change).permit(:new_email) 
  end
end
