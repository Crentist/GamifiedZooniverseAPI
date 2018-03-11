require "application_responder"

class ApplicationController < ActionController::API
  self.responder = ApplicationResponder

  include Response
  include ExceptionHandler
  include ActionController::HttpAuthentication::Token::ControllerMethods
  #include ActionView::Rendering
  #protect_from_forgery with: :null_session
  before_action :authenticate_user
  respond_to :json

  def authenticate_user
    if request.headers['Authorization'].present?
      authenticate_or_request_with_http_token do |token|
        begin
          jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first

          @current_user_id = jwt_payload['id']
        rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
          head :unauthorized
          #return false
        end
      end
    else
      head :unauthorized
    end
  end

  private

  #def authenticate_user!(options = {})
  #  head :unauthorized unless signed_in?
  #end

  def signed_in?
    @current_user_id.present?
  end    
end
