# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  skip_before_action :authenticate_user

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    user = User.find_by_handle(sign_in_params[:handle])

    if user&.valid_password?(sign_in_params[:password])
      @current_user = user
      #@current_user.generate_jwt
    else
      render json:
        {
          errors:
            {
              'handle or password' => ['is invalid']
            }
        },
             status: :unprocessable_entity
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   byebug
  #   if @current_user
  #     @current_user.sign_out
  #     render json: {"message": "Cerrada sesión del usuario"},
  #            status: :ok
  #   end
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def configure_sign_in_params
    #byebug
    devise_parameter_sanitizer.permit(:sign_in, keys: [:handle])
  end  
end
