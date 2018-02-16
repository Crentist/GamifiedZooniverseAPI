class SessionsController < ApiController
  before_action :authenticate, only: [:destroy]

  def create
    user = User.find_by_handle(params[:user][:handle])

    if user && user.valid_password?(params[:user][:password])
      user.generate_auth_token

      render json: {auth_token: user.auth_token}, status: :ok
    else
      render json: {error: 'Credenciales inválidas'}, status: :unauthorized
    end
  end

  def destroy
    current_user.clean_auth_token

    head :ok
  end
end
