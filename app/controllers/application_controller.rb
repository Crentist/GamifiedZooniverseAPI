class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found  

  protected

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @current_user = User.find_by(auth_token: token)
    end

    return nil unless @current_user

    if @current_user.auth_token_expires_at < Time.now
      render_expired
    else
      @current_user.refresh_token
    end
  end

  def request_http_token_authentication(realm = 'Application', msg = nil)
    render json: {error: 'Token incorrecto'}, status: :unauthorized
  end

  def render_expired
    render json: {error: 'Token expirado'}, status: :unauthorized
  end

  def current_user
    @current_user
  end

  def render_forbidden
    render json: {error: 'Acceso denegado'}, status: :forbidden
  end

  def record_not_found
    render json: {error: I18n.t('errors.not_found', resource_id: params[:id])}, status: :bad_request
  end  
end
