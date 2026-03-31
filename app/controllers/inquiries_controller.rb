class InquiriesController < ApplicationController
  def new
    @inquiry = Inquiry.new

    if parking_manager_signed_in?
      @inquiry.name = current_parking_manager.decorate.full_name
      @inquiry.email = current_parking_manager.email
    end
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)
    @inquiry.parking_manager_id = current_parking_manager.id if parking_manager_signed_in?

    if @inquiry.save
      if parking_manager_signed_in?
        redirect_to my_dashboard_root_path, success: "お問い合わせを送信しました。"
      else
        redirect_to thanks_contact_path
      end

    else
      flash.now[:danger] = "入力内容に不備があります。"
      render :new, status: :unprocessable_entity
    end
  end

  def thanks; end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :email, :subject, :message)
  end
end
