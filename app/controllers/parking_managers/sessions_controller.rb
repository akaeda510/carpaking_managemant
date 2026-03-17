# frozen_string_literal: true

class ParkingManagers::SessionsController < Devise::SessionsController
   # before_action :configure_sign_in_params, only: [:create]

   # GET /resource/sign_in
   # def new
   #   super
   # end

   # POST /resource/sign_in
   def create
     super do |resource|
       if resource.persisted?
         begin
           NotificationMailer.login_notification(resource).deliver
           rescue => e
             Rails.logger.error "メール送信エラー: #{e.message}"
         end
       end
     end
   end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
